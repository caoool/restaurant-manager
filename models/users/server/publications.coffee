Meteor.publish 'users.all', ->
  return @ready() if !@userId || !Roles.userIsInRole @userId, 'admin'
  Meteor.users.find {},
    fileds:
      username: 1
      profile: 1
      roles: 1
