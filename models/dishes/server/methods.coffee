Meteor.methods
	'dishes.insert': (options) ->
		return if !@userId || !Roles.userIsInRole @userId, 'admin'
		Dishes.insert options

	'dishes.remove': (_id) ->
		return if !@userId || !Roles.userIsInRole @userId, 'admin' 
		Dishes.remove _id: _id

	'dishes.update': (options) ->
		return if !@userId || !Roles.userIsInRole @userId, 'admin'
		Dishes.update options.dishId, $set: options