Meteor.publish 'instance agent', (instanceId, hostname) ->
  console.log 'Instance', instanceId, 'connected'

  @onStop ->
    Instances.update instanceId, $set: online: false

  if instance = Instances.findOne instanceId
    Instances.update instanceId, $set: online: true
  else
    Instances.insert
      _id: instanceId
      firstSeen: new Date()
      name: hostname
      online: true
