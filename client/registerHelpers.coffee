UI.registerHelper 'join', (array) ->
	array.join ' '

UI.registerHelper '$inArray', (s, a) ->
	a.indexOf(s) > -1