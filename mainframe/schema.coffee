root = global ? window
root.root = root

root.Instances = new Meteor.Collection 'instances'
Instances.attachSchema new SimpleSchema
  arn:       type: String, optional: true
  firstSeen: type: Date
  name:      type: String, max: 255
  type:      type: String, max: 50
  online:    type: Boolean, defaultValue: false

  deps:      type: [new SimpleSchema
    type:    type: String
    name:    type: String
    version: type: String, optional: true
    target:  type: String, optional: true
  ], optional: true

root.Roles = new Meteor.Collection 'roles'
Roles.attachSchema new SimpleSchema
  createdAt: type: Date
  name:      type: String, max: 255

  versions:  type: [new SimpleSchema
    date:    type: Date
    latest:  type: Boolean
    code:    type: String
    amiId:   type: String

    deps:      type: [new SimpleSchema
      type:    type: String
      name:    type: String
      version: type: String, optional: true
      target:  type: String, optional: true
    ]
  ]

root.Groups = new Meteor.Collection 'groups'
Groups.attachSchema new SimpleSchema
  arn:       type: String, optional: true
  name:      type: String, max: 255
  instances: type: [String]

  deps:      type: [new SimpleSchema
    type:    type: String
    name:    type: String
    version: type: String, optional: true
    target:  type: String, optional: true
  ], optional: true

root.Files = new Meteor.Collection 'files'
Files.attachSchema new SimpleSchema
  name:      type: String, max: 255
  type:      type: String, allowedValues: ['config', 'key', 'data']

  versions:  type: [new SimpleSchema
    date:    type: Date
    latest:  type: Boolean
    code:    type: String

    data:    type: String
  ], optional: true
