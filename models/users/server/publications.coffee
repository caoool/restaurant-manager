Meteor.publish 'users.all', ->
  return @ready() if !@userId || !Roles.userIsInRole @userId, 'admin'
  Meteor.users.find {},
    fileds: Meteor.users.publicFields
