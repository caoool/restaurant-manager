Schema = {}

Schema.UserProfile = new SimpleSchema
  name: 
    type: String
    optional: true
  phone:
    type: String
    optional: true

Schema.User = new SimpleSchema
  username:
    type: String
  createdAt:
    type: Date
  profile:
    type: Schema.UserProfile
    optional: true
  services:
    type: Object
    optional: true
    blackbox: true
  roles:
    type: Array
    optional: true
  'roles.$':
    type: String

Meteor.users.attachSchema Schema.User

Meteor.users.publicFields =
  id: 1
  username: 1
  profile: 1
  roles: 1

Tables.helpers