IR_BeforeHooks =
	isLoggedIn: ->
		if !Meteor.userId()
			@redirect 'login'
			@next()
		else
			@next()

	isAuthorized: ->
		if Roles.userIsInRole Meteor.userId(), Router.current().route.options.authorizations
			@next()
		else
			@render 'unauthorized'
			@next()

Router.onBeforeAction IR_BeforeHooks.isLoggedIn
Router.onBeforeAction IR_BeforeHooks.isAuthorized

Router.route '/',
	name: 'landing'
	template: 'login'

Router.route '/login',
	name: 'login'
	template: 'login'

Router.route '/admin',
	name: 'admin'
	template: 'admin_dishes'
	layoutTemplate: 'admin_layout'
	authorizations: ['admin']

Router.route '/admin/dishes',
	name: 'admin_dishes'
	template: 'admin_dishes'
	layoutTemplate: 'admin_layout'
	authorizations: ['admin']

Router.route '/admin/tables',
	name: 'admin_tables'
	template: 'admin_tables'
	layoutTemplate: 'admin_layout'
	authorizations: ['admin']

Router.route '/admin/staff',
	name: 'admin_staff'
	template: 'admin_staff'
	layoutTemplate: 'admin_layout'
	authorizations: ['admin']

Router.route '/unauthorized',
	name: 'unauthorized'
	template: 'unauthorized'