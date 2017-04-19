delay = (ms, func) -> setTimeout func, ms

filtered = new Set

getFileContentAsBase64 = (file, callback) ->
	reader = new FileReader()
	reader.onloadend = (e) ->
		content = @.result
		callback content
	reader.readAsDataURL file

Template.admin_dishes.onCreated ->
	self = this
	self.autorun ->
		self.subscribe 'dishes.all'
		
		if self.subscriptionsReady()
			Materialize.updateTextFields()

			tags = {}
			options = {}
			autocompleteData = {}
			dishes = Dishes.find().fetch()
			for dish in dishes
				data_tag = []
				data_option = []
				if dish.tags
					for tag in dish.tags
						data_tag.push tag: tag
						# autocompleteData[tag] = null
				if dish.options
					for option in dish.options
						data_option.push tag: option
				tags[dish._id] = data_tag
				options[dish._id] = data_option
			for dish in dishes
				$(".admin_dishes .tags[dishId='"+dish._id+"']").material_chip
					placeholder: '  +类别'
					secondaryPlaceholder: '请输入类别'
					data: tags[dish._id]
					# autocompleteData: autocompleteData
				$(".admin_dishes .options[dishId='"+dish._id+"']").material_chip
					placeholder: '  +选项'
					secondaryPlaceholder: '请输入选项'
					data: options[dish._id]
					# autocompleteData: autocompleteData
			
			$('.admin_dishes .dishes').isotope
				itemSelector: '.dish'
				layoutMode: 'masonry'
			
Template.admin_dishes.onRendered ->
	$('.admin_dishes #remove_dish_modal').modal()
	delay 500, ->
		$('.admin_dishes .dishes').isotope
			itemSelector: '.dish'
			layoutMode: 'masonry'

Template.admin_dishes.events
	'click .admin_dishes #filter_all': (e) ->
		e.preventDefault()
		$('.admin_dishes .filter_all').removeClass 'btn'
		$('.admin_dishes .filter_all').addClass 'btn-flat'
		$('.admin_dishes #filter_all').removeClass 'btn-flat'
		$('.admin_dishes #filter_all').addClass 'btn'
		$('.dishes').isotope filter: '.dish'

	'click .admin_dishes .filter_all:not(#filter_all)': (e) ->
		e.preventDefault()
		if $(e.target).hasClass 'btn'
			$(e.target).removeClass 'btn'
			$(e.target).addClass 'btn-flat'
			filtered.delete '.' + e.currentTarget.text
			$('.dishes').isotope filter: setToString filtered
			if !filtered.size
				$('.admin_dishes #filter_all').removeClass 'btn-flat'
				$('.admin_dishes #filter_all').addClass 'btn'
		else
			$('.admin_dishes #filter_all').removeClass 'btn'
			$('.admin_dishes #filter_all').addClass 'btn-flat'
			$(e.target).removeClass 'btn-flat'
			$(e.target).addClass 'btn'
			filtered.add '.' + e.currentTarget.text
			$('.dishes').isotope filter: setToString filtered

	'click .admin_dishes #add_dish': (e) ->
		e.preventDefault()
		options = {}
		Meteor.call 'dishes.insert', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_dishes .dishes').isotope('reloadItems').isotope()
				Materialize.toast('加入新菜品成功!', 3000, 'rounded teal lighten-2')

	'click .admin_dishes .in_stock': (e) ->
		e.preventDefault()
		options = 
			dishId: @_id
			stock: 0
		Meteor.call 'dishes.update', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				Materialize.toast('库存修改成功!', 3000, 'rounded teal lighten-2')

	'click .admin_dishes .out_stock': (e) ->
		e.preventDefault()
		options = 
			dishId: @_id
			stock: 1
		Meteor.call 'dishes.update', options, (error, result) ->
			if error	
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				Materialize.toast('库存修改成功!', 3000, 'rounded teal lighten-2')

	'focusout .admin_dishes .new_name': (e) ->
		e.preventDefault()
		dish = Dishes.findOne @_id
		return if dish.name == e.target.value
		options =
			dishId: @_id
			name: e.target.value
		Meteor.call 'dishes.update', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				Materialize.toast('菜品名称修改成功!', 3000, 'rounded teal lighten-2')

	'focusout .admin_dishes .new_price': (e) ->
		e.preventDefault()
		dish = Dishes.findOne @_id
		return if dish.price.toString() == e.target.value
		options =
			dishId: @_id
			price: e.target.value
		Meteor.call 'dishes.update', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				Materialize.toast('菜品单价修改成功!', 3000, 'rounded teal lighten-2')
	
	'focusout .admin_dishes .new_unit': (e) ->
		e.preventDefault()
		dish = Dishes.findOne @_id
		return if dish.unit == e.target.value
		options =
			dishId: @_id
			unit: e.target.value
		Meteor.call 'dishes.update', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				Materialize.toast('菜品单位修改成功!', 3000, 'rounded teal lighten-2')

	'focusout .admin_dishes .new_description': (e) ->
		e.preventDefault()
		dish = Dishes.findOne @_id
		dish.description = '' if !dish.description
		return if dish.description == e.target.value
		options =
			dishId: @_id
			description: e.target.value
		Meteor.call 'dishes.update', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_dishes .dishes').isotope('reloadItems').isotope()
				Materialize.toast('菜品简介修改成功!', 3000, 'rounded teal lighten-2')

	'chip.add .admin_dishes .tags': (e) ->
		tags = []
		for tag in $(e.target).material_chip 'data'
			tags.push tag.tag
		options =
			dishId: @_id
			tags: tags
		Meteor.call 'dishes.update', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_dishes .dishes').isotope('reloadItems').isotope()
				Materialize.toast('菜品类型更新成功!', 3000, 'rounded teal lighten-2')

	'chip.delete .admin_dishes .tags': (e) ->
		tags = []
		for tag in $(e.target).material_chip 'data'
			tags.push tag.tag
		options =
			dishId: @_id
			tags: tags
		Meteor.call 'dishes.update', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_dishes .dishes').isotope('reloadItems').isotope()
				Materialize.toast('菜品类型更新成功!', 3000, 'rounded teal lighten-2')

	'chip.add .admin_dishes .options': (e) ->
		options_dish = []
		for option in $(e.target).material_chip 'data'
			options_dish.push option.tag
		options =
			dishId: @_id
			options: options_dish
		Meteor.call 'dishes.update', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_dishes .dishes').isotope('reloadItems').isotope()
				Materialize.toast('菜品选项更新成功!', 3000, 'rounded teal lighten-2')

	'chip.delete .admin_dishes .options': (e) ->
		options_dish = []
		for option in $(e.target).material_chip 'data'
			options_dish.push option.tag
		options =
			dishId: @_id
			options: options_dish
		Meteor.call 'dishes.update', options, (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_dishes .dishes').isotope('reloadItems').isotope()
				Materialize.toast('菜品类型更新成功!', 3000, 'rounded teal lighten-2')

	'click .admin_dishes .new_picture': (e) ->
		e.preventDefault()
		$(".admin_dishes .new_picture_holder[dishId='"+@_id+"']").click()

	'change .admin_dishes .new_picture_holder': (e) ->
		e.preventDefault()
		_id = @_id
		files = event.target.files
		getFileContentAsBase64 files[0], (content) ->
			if !content
				Materialize.toast('上传失败！', 3000, 'rounded red lighten-2')
			else
				options = 
					dishId: _id
					picture: content
				Meteor.call 'dishes.update', options, (error, result) ->
					if error
						Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
					else
						Materialize.toast('菜品图片更新成功!', 3000, 'rounded teal lighten-2')

	'click .admin_dishes .remove_dish_button': (e) ->
		e.preventDefault()
		Session.set 'SELECTED_DISH', @_id
		$('.admin_dishes #remove_dish_modal').modal 'open'

	'click .admin_dishes #remove_dish': (e) ->
		e.preventDefault()
		Meteor.call 'dishes.remove', Session.get('SELECTED_DISH'), (error, result) ->
			if error
				Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
			else
				$('.admin_dishes #remove_dish_modal').modal 'close'
				$('.admin_dishes .dishes').isotope
					itemSelector: '.dish'
					layoutMode: 'masonry'
				Materialize.toast('移除菜品成功!', 3000, 'rounded teal lighten-2')

Template.admin_dishes.helpers
	dishes: ->
		Dishes.find()
	
	tags: ->
		tags = new Set()
		dishes = Dishes.find().fetch()
		for dish in dishes
			if dish.tags
				for tag in dish.tags
					tags.add tag
		Array.from tags