Template.waiter_layout.onCreated ->
  @subscribe 'tables.all'

Template.waiter_layout.onRendered ->
  $('.waiter_layout #table_modal').modal()

Template.waiter_layout.events
  'click .waiter_layout #logout': (e) ->
    e.preventDefault()
    Session.clear()
    Meteor.logout()

  'click .waiter_layout #show_table_model': (e) ->
    e.preventDefault()
    $('.waiter_layout #table_modal').modal 'open'

  'click .waiter_layout #check_order': (e) ->
    e.preventDefault()
    if $('#order').css('width') == '600px'
      $('#order').css 'width', '0px'
      $('.panel').css 'opacity', '1'
    else
      $('#order').css 'width', '600px'
      $('.panel').css 'opacity', '0.15'

Template.waiter_layout.helpers
  tables: ->
    Tables.find()