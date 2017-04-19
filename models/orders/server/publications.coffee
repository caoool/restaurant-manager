Meteor.publish 'orders.all', ->
  return @ready() if !@userId
  Orders.find {},
    fields: Orders.publicFields

Meteor.publish 'orders', (options) ->
  return @ready() if !@userId
  Orders.find options,
    fields: Orders.publicFields