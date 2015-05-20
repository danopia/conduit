Router.configure
  layoutTemplate: 'Layout'
  loadingTemplate: 'Loading'

Router.route 'instances',
  waitOn: -> Meteor.subscribe 'data'
  data: ->
    instances: Instances.find().map (instance) ->
      instance.uptime = Tasks.findOne
        type: 'exec'
        input: command: '/usr/bin/uptime'
        targets: type: 'instance', id: instance._id
      , sort: queueDate: -1
      return instance
Router.route 'groups'
Router.route 'roles'
Router.route 'files'
Router.route 'tasks'
Router.route 'logs'

Router.route '/', -> @redirect 'groups'
