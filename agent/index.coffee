DDP = require 'ddp'
restify = require 'restify'
os = require 'os'

ddp = new DDP
  host:  process.argv[2] || '192.168.1.129'
  port: +process.argv[3] || 3000
  ssl:   false

ddp.connect (error, wasReconnect) ->
  return console.log "Connection error #{error.stack or error}" if error
  console.log 'Connected'

  metadataClient = restify.createStringClient
    url: 'http://instance-data.ec2.internal'
    retry: false # will hard fail quickly outside of EC2
  metadataClient.get '/latest/meta-data/instance-id/', (err, req, res, data) ->
    unless err
      setupAgent data
    else
      console.log "Metadata error #{err.stack or err}"

      require('getmac').getMac (err, mac) ->
        unless err
          setupAgent mac
        else
          console.log "GIVING UP - No ID source"

setupAgent = (id) ->
  ddp.subscribe 'instance agent', [id, os.hostname()], ->
    console.log 'identity received:', ddp.collections.instances[id]

updateTask = (id, update, cb) ->
  ddp.call '/tasks/update', [_id: id, update], cb

runTask = (task) ->
  updateTask task._id, $set:
    output: {}
    status: 'running'
    startDate: new Date()
  , ->

    spawn = require('child_process').spawn
    {command, args, options, data, encoding} = task.input
    {stdin, stdout, stderr} = process = spawn command, args, options

    stdin.write(data, encoding) if data
    stdin.end()

    stdout.on 'data', (data) ->
      updateTask task._id, $push:
        'output.stdout': data.toString(encoding)

    stderr.on 'data', (data) ->
      updateTask task._id, $push:
        'output.stderr': data.toString(encoding)

    process.on 'error', (err) ->
      updateTask task._id, $set:
        'output.error': name: err.name, message: err.message
        status: 'error'
        finishDate: new Date()

    process.on 'close', (code, signal) ->
      updateTask task._id, $set:
        'output.code': code
        'output.signal': signal
        status: 'done'
        finishDate: new Date()

observer = ddp.observe 'tasks'
observer.added = (id) -> runTask ddp.collections.tasks[id]
observer.changed = (id, oldFields, clearedFields, newFields) ->
observer.removed = (id, oldValue) ->
