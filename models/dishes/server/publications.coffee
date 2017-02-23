Meteor.publish 'dishes.all', ->
	return @ready() if !@userId
	Dishes.find {},
		fields: Dishes.publicFields