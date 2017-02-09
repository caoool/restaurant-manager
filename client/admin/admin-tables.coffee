delay = (ms, func) -> setTimeout func, ms

Template.admin_tables.onCreated ->
	Meteor.subscribe 'tables.all'

Template.admin_tables.onRendered ->
	delay '500', ->
		$('.admin_tables .tables').isotope
			itemSelector: '.table'
			layoutMode: 'masonry'

Template.admin_tables.events
	'click #add_table': (e) ->
		e.preventDefault()
		Meteor.call 'tables.insert', (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_tables .tables').isotope
					itemSelector: '.table'
					layoutMode: 'masonry'
				Materialize.toast('加入新台面成功!', 3000, 'rounded teal lighten-2')

	'click .remove_table': (e) ->
		e.preventDefault()
		Meteor.call 'tables.remove', @_id, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_tables .tables').isotope
					itemSelector: '.table'
					layoutMode: 'masonry'
				Materialize.toast('台面移除成功!', 3000, 'rounded teal lighten-2')

	'focusout .change_table_id': (e) ->
		e.preventDefault()
		table = Tables.findOne @_id
		return if table.id == e.target.value
		options =
			tableId: @_id
			updates: id: e.target.value
		Meteor.call 'tables.update', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				Materialize.toast('台面更新成功!', 3000, 'rounded teal lighten-2')

Template.admin_tables.helpers
	tables: ->
		Tables.find()