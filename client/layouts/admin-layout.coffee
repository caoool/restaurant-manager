Template.admin_layout.rendered = ->
	$('.admin_layout ul.tabs').tabs()

Template.admin_layout.events
	'click .admin_layout #logout': (e) ->
		e.preventDefault()
		Session.clear()
		Meteor.logout()

	'click .admin_layout #password_modal_pop': (e) ->
		e.preventDefault()
		$('.admin_layout #password_modal').openModal()

	'click .admin_layout #change_password': (e) ->
		e.preventDefault()
		password_old = $('.admin_layout #password_old').val()
		password_new = $('.admin_layout #password_new').val()
		password_validate = $('.admin_layout #password_validate').val()
		if password_new != password_validate
			Materialize.toast('密码验证不一致！', 3000, 'rounded red lighten-2')
		else
			Accounts.changePassword password_old, password_new, (error) ->
				if error
					Materialize.toast('初始密码错误!', 3000, 'rounded red lighten-2')
				else
					Materialize.toast('密码修改成功！', 3000, 'rounded teal lighten-2')
					$('.admin_layout #password_modal').closeModal()

	'click .admin_layout #dishes': (e) ->
		e.preventDefault()
		Session.setPersistent('SELECTED_TAB', 'dishes')
		Router.go '/admin/dishes'

	'click .admin_layout #tables': (e) ->
		e.preventDefault()
		Session.setPersistent('SELECTED_TAB', 'tables')
		Router.go '/admin/tables'

	'click .admin_layout #staff': (e) ->
		e.preventDefault()
		Session.setPersistent('SELECTED_TAB', 'staff')
		Router.go '/admin/staff'

	'click .admin_layout #settings': (e) ->
		e.preventDefault()
		Session.setPersistent('SELECTED_TAB', 'settings')
		Router.go '/admin/settings'