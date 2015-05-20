root = global ? window
root.root = root

Target = new SimpleSchema
  type:      type: String
  id:        type: String

Dependency = new SimpleSchema
  type:      type: String
  name:      type: String
  owner:     type: Target, optional: true
  version:   type: String, optional: true
  target:    type: String, optional: true

root.Instances = new Meteor.Collection 'instances'
Instances.attachSchema new SimpleSchema
  arn:       type: String, optional: true
  firstSeen: type: Date
  name:      type: String, max: 255
  type:      type: String
  online:    type: Boolean, defaultValue: false
  deps:      type: [Dependency], optional: true

root.Roles = new Meteor.Collection 'roles'
Roles.attachSchema new SimpleSchema
  createdAt: type: Date
  name:      type: String, max: 255
  owner:     type: Target

  versions:  type: [new SimpleSchema
    date:    type: Date
    latest:  type: Boolean
    code:    type: String
    amiId:   type: String
    deps:    type: [Dependency]
  ]

root.Groups = new Meteor.Collection 'groups'
Groups.attachSchema new SimpleSchema
  arn:       type: String, optional: true
  name:      type: String, max: 255
  instances: type: [String]

  deps:      type: [Dependency], optional: true

root.Files = new Meteor.Collection 'files'
Files.attachSchema new SimpleSchema
  name:      type: String, max: 255
  type:      type: String, allowedValues: ['config', 'key', 'data']
  owner:     type: Target

  versions:  type: [new SimpleSchema
    date:    type: Date
    latest:  type: Boolean
    code:    type: String

    data:    type: String
  ], optional: true

root.Tasks = new Meteor.Collection 'tasks'
Tasks.attachSchema new SimpleSchema
  type:      type: String, max: 255
  body:      type: Object, blackbox: true
  output:    type: Object, blackbox: true
  status:    type: String, max: 255

  owner:     type: Target
  targets:   type: [Target]
  recur:     type: Number

  queueDate: type: Date
  startDate: type: Date
  finishDate:type: Date

root.Logs = new Meteor.Collection 'logs'
Logs.attachSchema new SimpleSchema
  source:    type: Target
  file:      type: String
  firstSeen: type: Date
  lines:     type: [new SimpleSchema
    date:    type: Date
    text:    type: String
    pid:     type: Number, optional: true
    data:    type: Object, blackbox: true, optional: true
  ]

root.Packets = new Meteor.Collection 'packets'
Packets.attachSchema new SimpleSchema
  type:      type: String, max: 255
  body:      type: Object, blackbox: true
  status:    type: String, max: 255

  source:    type: Target
  target:    type: Target

  sendDate:  type: Date
  ackDate:   type: Date

root.Engines = new Meteor.Collection 'engines'
Engines.attachSchema new SimpleSchema
  source:    type: String
  config:    type: Object, blackbox: true
  deps:      type: [Dependency], optional: true
  enabled:   type: Boolean
