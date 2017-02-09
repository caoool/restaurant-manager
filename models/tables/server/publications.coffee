Meteor.publish 'tables.all', ->
	return @ready() if !@userId
	Tables.find {},
		fileds: Tables.publicFields