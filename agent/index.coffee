DDP = require 'ddp'
restify = require 'restify'
os = require 'os'

ddp = new DDP
  host: '192.168.1.129'
  port:  3000
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
    console.log 'identity received:', ddp.collections.instances
