delay = (ms, func) -> setTimeout func, ms

setToString = (set) ->
	ret = ''
	set.forEach (item) =>
		ret += item
		ret += ', '
	ret.slice 0, -2

filters = []
filtered = new Set

Template.admin_staff.onCreated ->
	Meteor.subscribe 'users.all'

Template.admin_staff.onRendered ->
	filters.push $('.admin_staff #filter_waiter')
	filters.push $('.admin_staff #filter_cashier')
	filters.push $('.admin_staff #filter_admin')
	filter = new Set
	delay '500', ->
		$('.staffs').isotope
			itemSelector: '.staff'
			layoutMode: 'masonry'

Template.admin_staff.events
	'click .admin_staff #filter_all': (e) ->
		e.preventDefault()
		$('.admin_staff #filter_all').removeClass 'btn-flat'
		$('.admin_staff #filter_all').addClass 'btn'
		for filter in filters
			filter.removeClass 'btn'
			filter.addClass 'btn-flat'
		$('.staffs').isotope filter: '.staff'

	'click .admin_staff #filter_waiter': (e) ->
		e.preventDefault()
		if $('.admin_staff #filter_waiter').hasClass 'btn'
			$('.admin_staff #filter_waiter').removeClass 'btn'
			$('.admin_staff #filter_waiter').addClass 'btn-flat'
			filtered.delete '.waiter'
			$('.staffs').isotope filter: setToString filtered
			toggleAll = false
			for filter in filters
				if filter.hasClass 'btn'
					toggleAll = true
					break
			if !toggleAll
				$('.admin_staff #filter_all').removeClass 'btn-flat'
				$('.admin_staff #filter_all').addClass 'btn'
				filtered.delete '.waiter'
				filtered.add '.staff'
				$('.staffs').isotope filter: setToString filtered
		else
			$('.admin_staff #filter_all').removeClass 'btn'
			$('.admin_staff #filter_all').addClass 'btn-flat'
			$('.admin_staff #filter_waiter').removeClass 'btn-flat'
			$('.admin_staff #filter_waiter').addClass 'btn'
			filtered.add '.waiter'
			filtered.delete '.staff'
			$('.staffs').isotope filter: setToString filtered

	'click .admin_staff #filter_cashier': (e) ->
		e.preventDefault()
		if $('.admin_staff #filter_cashier').hasClass 'btn'
			$('.admin_staff #filter_cashier').removeClass 'btn'
			$('.admin_staff #filter_cashier').addClass 'btn-flat'
			filtered.delete '.cashier'
			$('.staffs').isotope filter: setToString filtered
			toggleAll = false
			for filter in filters
				if filter.hasClass 'btn'
					toggleAll = true
					break
			if !toggleAll
				$('.admin_staff #filter_all').removeClass 'btn-flat'
				$('.admin_staff #filter_all').addClass 'btn'
				filtered.delete '.cashier'
				filtered.add '.staff'
				$('.staffs').isotope filter: setToString filtered
		else
			$('.admin_staff #filter_all').removeClass 'btn'
			$('.admin_staff #filter_all').addClass 'btn-flat'
			$('.admin_staff #filter_cashier').removeClass 'btn-flat'
			$('.admin_staff #filter_cashier').addClass 'btn'
			filtered.add '.cashier'
			filtered.delete '.staff'
			$('.staffs').isotope filter: setToString filtered

	'click .admin_staff #filter_admin': (e) ->
		e.preventDefault()
		if $('.admin_staff #filter_admin').hasClass 'btn'
			$('.admin_staff #filter_admin').removeClass 'btn'
			$('.admin_staff #filter_admin').addClass 'btn-flat'
			filtered.delete '.admin'
			$('.staffs').isotope filter: setToString filtered
			toggleAll = false
			for filter in filters
				if filter.hasClass 'btn'
					toggleAll = true
					break
			if !toggleAll
				$('.admin_staff #filter_all').removeClass 'btn-flat'
				$('.admin_staff #filter_all').addClass 'btn'
				filtered.delete '.admin'
				filtered.add '.staff'
				$('.admin_staff .staffs').isotope filter: setToString filtered
		else
			$('.admin_staff #filter_all').removeClass 'btn'
			$('.admin_staff #filter_all').addClass 'btn-flat'
			$('.admin_staff #filter_admin').removeClass 'btn-flat'
			$('.admin_staff #filter_admin').addClass 'btn'
			filtered.add '.admin'
			filtered.delete '.staff'
			$('.staffs').isotope filter: setToString filtered

	'click .admin_staff #add_staff_modal_pop': (e) ->
		e.preventDefault()
		$('.admin_staff #add_staff_modal').openModal()

	'click .admin_staff #add_staff': (e) ->
		e.preventDefault()
		profile =
			name: $('.admin_staff #name').val()
			phone: $('.admin_staff #phone').val()
		roles = []
		roles.push 'waiter' if $('.admin_staff #role_waiter').prop 'checked'
		roles.push 'cashier' if $('.admin_staff #role_cashier').prop 'checked'
		roles.push 'admin'if $('.admin_staff #role_admin').prop 'checked'
		options =
			username: $('.admin_staff #id').val()
			password: $('.admin_staff #id').val()
			profile: profile
			roles: roles
		Meteor.call 'users.createAccountFromAdmin', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_staff #add_staff_modal').closeModal()
				$('.admin_staff .staffs').isotope('reloadItems').isotope()
				Materialize.toast('加入新成员成功!', 3000, 'rounded teal lighten-2')
				
	'focusout .admin_staff .new_name': (e) ->
		e.preventDefault()
		user = Meteor.users.findOne @_id
		return if user.profile.name == e.target.value
		options =
			userId: @_id
			profile: 
				name: e.target.value
				phone: user.profile.phone
		Meteor.call 'users.updateProfile', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				Materialize.toast('更新成员资料成功!', 3000, 'rounded teal lighten-2')

	'focusout .admin_staff .new_phone': (e) ->
		e.preventDefault()
		user = Meteor.users.findOne @_id
		return if user.profile.phone == e.target.value
		options =
			userId: @_id
			profile: 
				name: user.profile.name
				phone: e.target.value
		Meteor.call 'users.updateProfile', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				Materialize.toast('更新成员资料成功!', 3000, 'rounded teal lighten-2')

	'click .admin_staff .remove_role_waiter': (e) ->
		e.preventDefault()
		options =
			action: 'remove'
			userId: @_id
			roles: 'waiter'
		Meteor.call 'users.updateRoles', options

	'click .admin_staff .add_role_waiter': (e) ->
		e.preventDefault()
		options =
			action: 'add'
			userId: @_id
			roles: 'waiter'
		Meteor.call 'users.updateRoles', options
		
	'click .admin_staff .remove_role_cashier': (e) ->
		e.preventDefault()
		options =
			action: 'remove'
			userId: @_id
			roles: 'cashier'
		Meteor.call 'users.updateRoles', options
		
	'click .admin_staff .add_role_cashier': (e) ->
		e.preventDefault()
		options =
			action: 'add'
			userId: @_id
			roles: 'cashier'
		Meteor.call 'users.updateRoles', options
		
	'click .admin_staff .remove_role_admin': (e) ->
		e.preventDefault()
		options =
			action: 'remove'
			userId: @_id
			roles: 'admin'
		Meteor.call 'users.updateRoles', options
		
	'click .admin_staff .add_role_admin': (e) ->
		e.preventDefault()
		options =
			action: 'add'
			userId: @_id
			roles: 'admin'
		Meteor.call 'users.updateRoles', options

	'click .admin_staff .remove_user_button': (e) ->
		e.preventDefault()
		Session.set 'USER_SELECTED', @_id
		$('.admin_staff #remove_user_modal').openModal()

	'click .admin_staff #remove_user': (e) ->
		e.preventDefault()
		Meteor.call 'users.remove', Session.get('USER_SELECTED'), (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_staff #remove_user_modal').closeModal()
				$('.admin_staff .staffs').isotope
					itemSelector: '.staff'
					layoutMode: 'masonry'
				Materialize.toast('移除成员成功!', 3000, 'rounded teal lighten-2')

	'click .admin_staff .set_user_password_button': (e) ->
		e.preventDefault()
		Session.set 'USER_SELECTED', @_id
		$('.admin_staff #set_user_password_modal').openModal()

	'click .admin_staff #set_user_password': (e) ->
		e.preventDefault()
		options = 
			userId: Session.get 'USER_SELECTED'
			newPassword: $('.admin_staff #user_new_password').val()
		Meteor.call 'users.setPassword', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_staff #set_user_password_modal').closeModal()
				Materialize.toast('修改成员密码成功!', 3000, 'rounded teal lighten-2')
						
Template.admin_staff.helpers
	staff: ->
		Meteor.users.find _id: $ne: Meteor.userId()