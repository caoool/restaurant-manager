Meteor.publish 'tables', ->
	Tables.find()
