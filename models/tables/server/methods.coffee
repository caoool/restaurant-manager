Meteor.methods
	'tables.insert': ->
		return if !@userId || !Roles.userIsInRole @userId, 'admin'
		Tables.insert {}

	'tables.remove': (_id) ->
		return if !@userId || !Roles.userIsInRole @userId, 'admin'
		Tables.remove _id: _id

	'tables.update': (options) ->
		return if !@userId || !Roles.userIsInRole @userId, 'admin'
		Tables.update options.tableId, $set: options.updates