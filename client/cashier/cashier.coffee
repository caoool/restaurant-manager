Template.cashier.onCreated ->
  @subscribe 'tables.all'
  @subscribe 'orders.all'

Template.cashier.onRendered ->
  $('.cashier #check_modal').modal
    dismissible: false

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
    $('.cashier #check_modal').modal 'open'

  'click .cashier #check_confirm': (e) ->
    e.preventDefault()
    options_table =
      tableId: Session.get 'TABLE_SELECTED'
      updates:
        reserved: false
        occupied: false
    options_order =
      tableId: Session.get 'TABLE_SELECTED'
      actual: $('.cashier #actual').val()
      method: $('.cashier input[name=method]:checked').val()
    Meteor.call 'orders.store', options_order, (error, result) ->
      if error
        Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
      else
        Meteor.call 'tables.update', options_table, (error, result) ->
          if error
            Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
          else
            Materialize.toast('结账成功!', 3000, 'rounded teal lighten-2')
            $('.cashier #check_modal').modal 'close'

  'click .cashier .remove_dish': (e) ->
    e.preventDefault()
    dish = Dishes.findOne @_id
    dishToRemove =
      name: e.target.getAttribute 'dish_name'
      options: e.target.getAttribute 'dish_options'
    options =
      orderId: Orders.findOne()._id
      updates: $pull: dishes: dishToRemove
    Meteor.call 'orders.update', options, (error, result) ->
      if error
        Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
      else
        Materialize.toast('菜品删除成功!', 3000, 'rounded teal lighten-2')

  'click .cashier .add_dish_count': (e) ->
    e.preventDefault()
    dishName = e.target.getAttribute 'dish_name'
    dishOptions = e.target.getAttribute 'dish_options'
    dishOptions = '' if !dishOptions
    dishCount = Number(e.target.getAttribute('dish_count')) + 1
    options =
      orderId: 
        _id: Orders.findOne()._id
        dishes:
          $elemMatch:
            name: dishName
            options: dishOptions
      updates: $set: 'dishes.$.count': dishCount
    Meteor.call 'orders.update', options, (error, result) ->
      if error
        Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
      else
        Materialize.toast('菜品数量更新成功!', 3000, 'rounded teal lighten-2')

  'click .cashier .remove_dish_count': (e) ->
    e.preventDefault()
    dish = Dishes.findOne @_id
    dishName = e.target.getAttribute 'dish_name'
    dishOptions = e.target.getAttribute 'dish_options'
    dishOptions = '' if !dishOptions
    dishCount = Number(e.target.getAttribute('dish_count')) - 1
    if dishCount <= 0
      dishToRemove =
        name: dishName
        options: dishOptions
      options =
        orderId:
          _id: Orders.findOne()._id
          dishes:
            $elemMatch:
              name: dishName
              options: dishOptions
        updates: $pull: dishes: dishToRemove
      Meteor.call 'orders.update', options, (error, result) ->
        if error
          Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
        else
          Materialize.toast('菜品删除成功!', 3000, 'rounded teal lighten-2')
    else
      options =
        orderId: 
          _id: Orders.findOne()._id
          dishes:
            $elemMatch:
              name: dishName
              options: dishOptions
        updates: $set: 'dishes.$.count': dishCount
      Meteor.call 'orders.update', options, (error, result) ->
        if error
          Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
        else
          Materialize.toast('菜品数量更新成功!', 3000, 'rounded teal lighten-2')

Template.cashier.helpers
  tables: ->
    Tables.find()

  tableId_selected: ->
    Session.get 'TABLE_SELECTED'

  table_selected: ->
    Tables.findOne Session.get 'TABLE_SELECTED'

  order: ->
    Orders.findOne tableId: Session.get 'TABLE_SELECTED'