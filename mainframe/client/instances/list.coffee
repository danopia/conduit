Template.Instances.events
  'click .uptime': ->
    Tasks.insert
      type: 'exec'
      input: command: '/usr/bin/uptime'
      owner: type: 'user', id: 'filler'
      targets: [type: 'instance', id: @_id]
      queueDate: new Date()
