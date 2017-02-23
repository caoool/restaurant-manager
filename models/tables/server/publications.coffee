Meteor.publish 'tables.all', ->
	return @ready() if !@userId
	Tables.find {},
		fields: Tables.publicFields