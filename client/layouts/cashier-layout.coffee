Template.cashier_layout.events
  'click .cashier_layout #logout': (e) ->
    e.preventDefault()
    Session.clear()
    Meteor.logout()