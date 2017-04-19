class DishesCollection extends Mongo.Collection
	insert: (dish, callback) ->
		super dish, callback

	update: (selector, modifier, callback) ->
    super selector, modifier, callback

  remove: (selector, callback) ->
    super selector, callback

@Dishes = new DishesCollection 'dishes'

Dishes.deny
	insert: -> yes
	update: -> yes
	remove: -> yes

Dishes.schema = new SimpleSchema
	name:
		type: String
		defaultValue: '未命名'
	description:
		type: String
		optional: true
	price:
		type: Number
		defaultValue: 0
	unit:
		type: String
		defaultValue: '份'
	stock:
		type: Number
		defaultValue: 1
	picture:
		type: String
		optional: true
	tags:
		type: [String]
		optional: true
	options:
		type: [String]
		optional: true

Dishes.attachSchema Dishes.schema

Dishes.publicFields =
	name: 1
	description: 1
	price: 1
	unit: 1
	stock: 1
	picture: 1
	tags: 1
	options: 1

Dishes.helpers
	