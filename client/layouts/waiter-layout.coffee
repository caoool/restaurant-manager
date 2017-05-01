Template.waiter_layout.onCreated ->
  @subscribe 'tables.all'
  @subscribe 'orders', tableId: Session.get 'TABLE_SELECTED'

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
    if $('#order').css('width') == '900px'
      $('#order').css 'width', '0px'
      $('.panel').css 'opacity', '1'
    else
      $('#order').css 'width', '900px'
      $('.panel').css 'opacity', '0.15'

  'click .waiter_layout .select_table': (e) ->
    e.preventDefault()
    Session.setPersistent 'TABLE_SELECTED', @_id
    $('.waiter_layout #table_modal').modal 'close'

  'click .waiter_layout .remove_dish': (e) ->
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

  'click .waiter_layout .add_dish_count': (e) ->
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

  'click .waiter_layout .remove_dish_count': (e) ->
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

  'click .waiter_layout #confirm': (e) ->
    e.preventDefault()
    options =
      orderId:
        _id: Orders.findOne()._id
      updates: $set: ready: true
    Meteor.call 'orders.update', options, (error, result) ->
      if error
        Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
      else
        Materialize.toast('下单成功，开始烹饪!', 3000, 'rounded teal lighten-2')

  'click .waiter_layout .finish': (e) ->
    e.preventDefault()
    dishName = e.target.getAttribute 'dish_name'
    dishOptions = e.target.getAttribute 'dish_options'
    dishOptions = '' if !dishOptions
    options =
      orderId:
        _id: Orders.findOne._id
        dishes:
          $elemMatch:
            name: dishName
            options: dishOptions
      updates: $set: 'dishes.$.status': 'finished'
    Meteor.call 'orders.update', options, (error, result) ->
      if error
        Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
      else
        Materialize.toast('菜品已送达!', 3000, 'rounded teal lighten-2')

Template.waiter_layout.helpers
  tables: ->
    Tables.find()

  table_selected: ->
    Tables.findOne Session.get 'TABLE_SELECTED'

  order: ->
    Orders.findOne()