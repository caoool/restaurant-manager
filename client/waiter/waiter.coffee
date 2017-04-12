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
      