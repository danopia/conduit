Meteor.publish 'data', -> [
  Instances.find()
  Roles.find()
  Files.find()
  Groups.find()
]
