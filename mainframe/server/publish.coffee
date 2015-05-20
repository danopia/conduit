Meteor.publish 'data', -> [
  Instances.find()
  Roles.find()
  Files.find()
  Groups.find()
  Tasks.find()
  Logs.find()
  Packets.find()
  Engines.find()
]
