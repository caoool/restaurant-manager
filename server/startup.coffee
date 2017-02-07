Meteor.startup ->
  if Tables.find().count() == 0
    Tables.insert id: n for n in [1..15]

  if Meteor.users.find().count() == 0
    Accounts.createUser
      username: 'admin'
      password: 'admin'
    Roles.addUsersToRoles Meteor.users.findOne()._id, ['admin']
