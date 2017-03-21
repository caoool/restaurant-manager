Template.login.events
	'submit form': (e) ->
		e.preventDefault()

	'click #waiter_login': (e) ->
		e.preventDefault()
		username = $('#username').val()
		password = $('#password').val()
		Meteor.loginWithPassword username, password, (error) ->
			if error
				Materialize.toast('用户名或密码错误！', 3000, 'rounded red lighten-2')
			else
				Router.go 'waiter'

	'click #cashier_login': (e) ->
		e.preventDefault()
		username = $('#username').val()
		password = $('#password').val()
		Meteor.loginWithPassword username, password, (error) ->
			if error
				Materialize.toast('用户名或密码错误！', 3000, 'rounded red lighten-2')
			else
				Router.go 'cashier'

	'click #admin_login': (e) ->
		e.preventDefault()
		username = $('#username').val()
		password = $('#password').val()
		Meteor.loginWithPassword username, password, (error) ->
			if error
				Materialize.toast('用户名或密码错误！', 3000, 'rounded red lighten-2')
			else
				Router.go 'admin'