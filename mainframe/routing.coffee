Router.configure
  layoutTemplate: 'Layout'
  loadingTemplate: 'Loading'

Router.route 'instances'# waitOn: -> Meteor.subscribe 'person', @params._id
Router.route 'groups'
Router.route 'roles'
Router.route '/', -> @redirect 'groups'
