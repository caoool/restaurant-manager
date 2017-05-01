Template.kitchen.onCreated ->
  @subscribe 'orders.all'

Template.kitchen.onRendered ->
  $('.kitchen ul.tabs').tabs()

Template.kitchen.events
  'click .kitchen .cook': (e) ->
    e.preventDefault()
    dishName = @name
    dishOptions = @options
    dishTableName = @tableName
    order = Orders.findOne
      'dishes.name': dishName
      'dishes.options': dishOptions
      'tableName': dishTableName
    if order
      options =
        orderId:
          _id: order._id
          dishes:
            $elemMatch:
              name: dishName
              options: dishOptions
        updates: $set: 'dishes.$.status': 'cooking'
      Meteor.call 'orders.update', options, (error, result) ->
        if error
          Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
        else
          Materialize.toast('烹饪开始!', 3000, 'rounded teal lighten-2')

  'click .kitchen .finish': (e) ->
    e.preventDefault()
    dishName = @name
    dishOptions = @options
    dishTableName = @tableName
    order = Orders.findOne
      'dishes.name': dishName
      'dishes.options': dishOptions
      'tableName': dishTableName
    if order
      options =
        orderId:
          _id: order._id
          dishes:
            $elemMatch:
              name: dishName
              options: dishOptions
        updates: $set: 'dishes.$.status': 'delivering'
      Meteor.call 'orders.update', options, (error, result) ->
        if error
          Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
        else
          Materialize.toast('烹饪完成，等待送桌!', 3000, 'rounded teal lighten-2')

  'click .kitchen .revert': (e) ->
    e.preventDefault()
    dishName = @name
    dishOptions = @options
    dishTableName = @tableName
    order = Orders.findOne
      'dishes.name': dishName
      'dishes.options': dishOptions
      'tableName': dishTableName
    if order
      options =
        orderId:
          _id: order._id
          dishes:
            $elemMatch:
              name: dishName
              options: dishOptions
        updates: 
          $set: 
            'dishes.$.status': 'waiting'
            'dishes.$.time': new Date()
      Meteor.call 'orders.update', options, (error, result) ->
        if error
          Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
        else
          Materialize.toast('菜品已撤回返工！', 3000, 'rounded teal lighten-2')

Template.kitchen.helpers
  dishes_to_cook: ->
    orders = Orders.find().fetch()
    dishes = []
    for order in orders
      if order.ready
        for dish in order.dishes
          if dish.status == 'waiting' or dish.status == 'cooking'
            dish.tableName = order.tableName
            dishes.push dish
    dishes.sort (a, b) ->
      b.time - a.time

  dishes_to_deliver: ->
    orders = Orders.find().fetch()
    dishes = []
    for order in orders
      if order.ready
        for dish in order.dishes
          if dish.status == 'delivering'
            dish.tableName = order.tableName
            dish.waiterName = order.waiterName
            dishes.push dish
    dishes.sort (a, b) ->
      b.time - a.time