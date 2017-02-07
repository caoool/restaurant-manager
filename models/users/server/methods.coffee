Meteor.methods
  'users.createAccountFromAdmin': (options) ->
    return if !@userId || !Roles.userIsInRole @userId, 'admin'
    Accounts.createUser options
    user = Meteor.users.findOne username: options.username
    Roles.addUsersToRoles user._id, options.roles

  'users.remove': (_id) ->
    return if !@userId || !Roles.userIsInRole @userId, 'admin'
    Meteor.users.remove _id: _id

  'users.setPassword': (options) ->
    return if !@userId || !Roles.userIsInRole @userId, 'admin'
    Accounts.setPassword options.userId, options.newPassword

  'users.updateProfile': (options) ->
    return if !@userId || !Roles.userIsInRole @userId, 'admin'
    Meteor.users.update options.userId, $set: profile: options.profile

  'users.addToRoleWithUsername': ({username, roles}) ->
    return if !@userId || !Roles.userIsInRole @userId, 'admin'
    user = Meteor.users.findOne username: username
    Roles.addUsersToRoles user._id, roles

  'users.updateRoles': (options) ->
     Roles.addUsersToRoles options.userId, options.roles if options.action == 'add'
     Roles.removeUsersFromRoles options.userId, options.roles if options.action == 'remove'