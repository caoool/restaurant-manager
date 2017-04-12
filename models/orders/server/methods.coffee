Meteor.methods
  'orders.insert': (options) ->
    return if !@userId
    Orders.insert options

  'orders.remove': (_id) ->
    return if !@userId
    Orders.remove _id: _id

  'orders.update': (options) ->
    return if !@userId
    Orders.update options.orderId, $set: options.updates

  'orders.store': (tableId) ->
    return if !@userId
    OrdersStored.insert Orders.findOne tableId: tableId
    Orders.remove tableId: tableId