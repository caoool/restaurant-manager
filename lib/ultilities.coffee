@delay = (ms, func) -> setTimeout func, ms

@setToString = (set) ->
	ret = ''
	set.forEach (item) =>
		ret += item
		ret += ', '
	ret.slice 0, -2