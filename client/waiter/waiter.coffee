delay = (ms, func) -> setTimeout func, ms

filtered = new Set

getFileContentAsBase64 = (file, callback) ->
  reader = new FileReader()
  reader.onloadend = (e) ->
    content = @.result
    callback content
  reader.readAsDataURL file

Template.waiter.onCreated ->
  self = this
  # @subscribe 'orders', tableId: Session.get 'TABLE_SELECTED' 
  self.autorun ->
    self.subscribe 'dishes.all'
    $('.waiter .dishes').isotope
      itemSelector: '.dish'
      layoutMode: 'masonry'

Template.waiter.onRendered ->
  delay 500, ->
    $('.waiter .dishes').isotope
      itemSelector: '.dish'
      layoutMode: 'masonry'

Template.waiter.events
  'click .waiter #filter_all': (e) ->
    e.preventDefault()
    $('.waiter .filter_all').removeClass 'btn'
    $('.waiter .filter_all').addClass 'btn-flat'
    $('.waiter #filter_all').removeClass 'btn-flat'
    $('.waiter #filter_all').addClass 'btn'
    $('.dishes').isotope filter: '.dish'

  'click .waiter .filter_all:not(#filter_all)': (e) ->
    e.preventDefault()
    if $(e.target).hasClass 'btn'
      $(e.target).removeClass 'btn'
      $(e.target).addClass 'btn-flat'
      filtered.delete '.' + e.currentTarget.text
      $('.dishes').isotope filter: setToString filtered
      if !filtered.size
        $('.waiter #filter_all').removeClass 'btn-flat'
        $('.waiter #filter_all').addClass 'btn'
    else
      $('.waiter #filter_all').removeClass 'btn'
      $('.waiter #filter_all').addClass 'btn-flat'
      $(e.target).removeClass 'btn-flat'
      $(e.target).addClass 'btn'
      filtered.add '.' + e.currentTarget.text
      $('.dishes').isotope filter: setToString filtered

  'click .waiter .add_dish': (e) ->
    e.preventDefault()
    options_dish = ''
    query = '.option[dishId="' + @_id + '"]:checked'
    $.each $(query), ->
      options_dish += $(this).val() + ' '
    options_dish = options_dish.replace /\s+$/, ''
    options_dish = '' if !options_dish
    dish = Dishes.findOne @_id
    order = Orders.findOne
      dishes:
        $elemMatch:
          name: dish.name
          options: options_dish
    if order
      options =
        orderId: 
          _id: order._id
          dishes:
            $elemMatch:
              name: dish.name
              options: options_dish
        updates: $inc: 'dishes.$.count': 1
      console.log options
      Meteor.call 'orders.update', options, (error, result) ->
        if error
          Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
        else
          Materialize.toast('菜品数量更新成功!', 3000, 'rounded teal lighten-2')
    else
      dishToAdd =
        name: dish.name
        price: dish.price
        unit: dish.unit
        count: 1
        options: options_dish
        time: new Date()
        status: 'waiting'
      options =
        orderId: Orders.findOne()._id
        updates: $push: dishes: dishToAdd
      Meteor.call 'orders.update', options, (error, result) ->
        if error
          Materialize.toast(error.reason, 3000, 'rounded red lighten-2')
        else
          Materialize.toast('菜品添加成功!', 3000, 'rounded teal lighten-2')

Template.waiter.helpers
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

  order: ->
    Orders.findOne()
      