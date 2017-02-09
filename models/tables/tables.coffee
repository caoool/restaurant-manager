class TablesCollection extends Mongo.Collection
  insert: (table, callback) ->
    super table, callback

  update: (selector, modifier, callback) ->
    super selector, modifier, callback

  remove: (selector, callback) ->
    super selector, callback

@Tables = new TablesCollection 'tables'

Tables.deny
  insert: -> yes
  update: -> yes
  remove: -> yes

Tables.schema = new SimpleSchema
  id:
    type: String
    optional: true
    autoValue: ->
      if !@value
        '未命名'
      else
        @value
  reserved:
    type: Boolean
    defaultValue: false
    optional: true
  occupied:
    type: Boolean
    defaultValue: false
    optional: true

Tables.attachSchema Tables.schema

Tables.publicFields =
  id: 1
  reserved: 1
  occupied: 1

Tables.helpers