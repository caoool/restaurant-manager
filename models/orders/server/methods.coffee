Meteor.methods
  'orders.insert': (options) ->
    return if !@userId
    Orders.insert options

  'orders.remove': (_id) ->
    return if !@userId
    Orders.remove _id: _id

  'orders.update': (options) ->
    return if !@userId
    Orders.update options.orderId, options.updates, (error, result) ->
      if error
        return error
      else
        total = 0
        order = Orders.findOne options.orderId
        for dish in order.dishes
          total += dish.price * dish.count
        Orders.update options.orderId, $set: total: total

  'orders.store': (tableId) ->
    return if !@userId
    OrdersStored.insert Orders.findOne tableId: tableId
    Orders.remove tableId: tableId