class OrdersCollection extends Mongo.Collection
  insert: (order, callback) ->
    super order, callback

  update: (selector, modifier, callback) ->
    super selector, modifier, callback

  remove: (selector, callback) ->
    super selector, callback

@Orders = new OrdersCollection 'orders'
@OrdersStored = new OrdersCollection 'orders_stored'

Orders.deny
  insert: -> yes
  update: -> yes
  remove: -> yes

OrdersStored.deny
  insert: -> yes
  update: -> yes
  remove: -> yes

Orders.schema = new SimpleSchema
  tableId:
    type: String
  tableName:
    type: String
  waiterId:
    type: String
    optional: true
  waiterName:
    type: String
    optional: true
  createdAt:
    type: Date
    autoValue: ->
      if @isInsert
        new Date()
      else if @isUpsert
        $setOnInsert: new Date()
      else
        @unset()
  checkedAt:
    type: Date
    optional: true
  dishes:
    type: Array
    optional: true
  'dishes.$':
    type: Object
  'dishes.$.name':
    type: String
  'dishes.$.price':
    type: Number
  'dishes.$.unit':
    type: String
  'dishes.$.count':
    type: Number
  total:
    type: Number
    autoValue: ->
      dishes = @field('dishes').value
      total = 0
      if dishes
        for dish in dishes
          total += dish.price * dish.count
      total
    optional: true

Orders.attachSchema Orders.schema
OrdersStored.attachSchema Orders.schema

Orders.publicFields =
  tableId: 1
  tableName: 1
  waiterId: 1
  waiterName: 1
  createdAt: 1
  checkedAt: 1
  dishes: 1
  total: 1
OrdersStored.publicFields = Orders.publicFields
