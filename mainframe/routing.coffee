Router.configure
  layoutTemplate: 'Layout'
  loadingTemplate: 'Loading'

Router.route 'instances',
  waitOn: -> Meteor.subscribe 'data'
  data: -> instances: Instances.find()
Router.route 'groups'
Router.route 'roles'
Router.route 'files'
Router.route 'tasks'
Router.route 'logs'

Router.route '/', -> @redirect 'groups'
