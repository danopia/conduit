Meteor.publish 'instance agent', (instanceId) ->
  console.log 'Instance', instanceId, 'connected'

  @onStop ->
    Instances.update instanceId, online: false

  if instance = Instances.findOne instanceId
    Instances.update instanceId, online: true
  else
    Instances.insert
      _id: instanceId
      firstSeen: new Date()
      name: require('os').hostname()
      online: true
