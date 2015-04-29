DDP = require 'ddp'
restify = require 'restify'

ddp = new DDP
  host: '75.82.27.176'
  port:  3000
  ssl:   false

ddp.connect (error, wasReconnect) ->
  return console.log "Connection error #{error.stack or error}" if error
  console.log 'Connected'

  metadataClient = restify.createStringClient url: 'http://169.254.169.254'
  metadataClient.get '/latest/meta-data/instance-id/', (err, req, res, data) ->
    return console.log "Metadata error #{err.stack or err}" if err

    ddp.subscribe 'instance agent', [data, require('os').hostname()], ->
      console.log 'identity received:'
      console.log ddp.collections.instances
