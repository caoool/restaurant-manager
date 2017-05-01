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
  'dishes.$.options':
    type: String
    optional: true
  'dishes.$.time':
    type: Date
    optional: true
  'dishes.$.status':
    type: String
    optional: true
  total:
    type: Number
    defaultValue: 0
    optional: true
  actual:
    type: Number
    defaultValue: 0
    optional: true
  method:
    type: String
    optional: true
  ready:
    type: Boolean
    optional: true
    defaultValue: false

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
  actual: 1
  method: 1
  ready: 1
OrdersStored.publicFields = Orders.publicFields
