Template.cashier.onCreated ->
  @subscribe 'tables.all'
  @subscribe 'orders.all'

Template.cashier.onRendered ->

Template.cashier.events
  'click .table': (e) ->
    e.preventDefault()
    tableId = e.target.getAttribute 'tableId'
    Session.setPersistent 'TABLE_SELECTED', tableId if tableId

  'click .reserve': (e) ->
    e.preventDefault()
    options =
      tableId: Session.get 'TABLE_SELECTED'
      updates: reserved: true
    Meteor.call 'tables.update', options, (error, result) ->
      if error
        Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
      else
        Materialize.toast('用餐预定成功!', 3000, 'rounded teal lighten-2')

  'click .occupy': (e) ->
    e.preventDefault()
    options_table =
      tableId: Session.get 'TABLE_SELECTED'
      updates:
        reserved: false
        occupied: true
    options_order =
      tableId: Session.get 'TABLE_SELECTED'
      tableName: e.target.getAttribute 'tableName'
    Meteor.call 'orders.insert', options_order, (error, result) ->
      if error
        Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
      else
        Meteor.call 'tables.update', options_table, (error, result) ->
          if error
            Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
          else
            Materialize.toast('开台成功!', 3000, 'rounded teal lighten-2')

  'click .print': (e) ->
    e.preventDefault()
    $('.order').print()

  'click .check': (e) ->
    e.preventDefault()
    options_table =
      tableId: Session.get 'TABLE_SELECTED'
      updates:
        reserved: false
        occupied: false
    options_order =
      tableId = Session.get 'TABLE_SELECTED'
    Meteor.call 'orders.store', options_order, (error, result) ->
      if error
        Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
      else
        Meteor.call 'tables.update', options_table, (error, result) ->
          if error
            Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
          else
            Materialize.toast('结账成功!', 3000, 'rounded teal lighten-2')

Template.cashier.helpers
  tables: ->
    Tables.find()

  tableId_selected: ->
    Session.get 'TABLE_SELECTED'

  table_selected: ->
    Tables.findOne Session.get 'TABLE_SELECTED'

  order: ->
    Orders.findOne tableId: Session.get 'TABLE_SELECTED'