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
  occupied:
    type: Boolean
    defaultValue: false

Tables.attachSchema Tables.schema

Tables.publicFields =
  id: 1
  occupied: 1

Tables.helpers