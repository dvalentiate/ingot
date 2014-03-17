_ = require 'lodash'
q = require 'q'

class Resource
	account: null
	getPath: ->
		@path
	getPropertySet: ->
		_.keys @propertyMap
	setAccessContext: (account) ->
		@account = account
	setResourceFactory: (resourceFactory) ->
		@resourceFactory = resourceFactory
	can: (verb, id = null) ->
		navigation = {
			path: ''
			idList: []
		}
		for rule in @access[verb]
			partList = rule.path.split '/'
			for part, i in partList
				if part == '{A}'
					navigation.idList.push @account
				else if path == '{true}'
					navigation.idList.push true
				else
					if i == 0
						navigation.path = part
					else
						navigation.path = navigation.path + '/' + part
	getPropertyDefinition: (key) ->
		if not @propertyMap[key]?
			return null
		definition = @propertyMap[key]
		if typeof definition == 'string'
			definition = {type: definition}
		return definition
	get: (key) ->
		definition = @getPropertyDefinition key
		
		if definition == null
			throw "INVALID PROPERTY - UNKNOWN : #{ key } is not a property of #{ @name }"
		if definition.type == 'reference'
			idPropertyDefinition = @getPropertyDefinition definition.idProperty
			if idPropertyDefinition == null
				throw "INVALID REFERENCE - UNKNOWN PROPERTY : #{ idPropertyDefinition } referenced by #{ key } definition but doesn't exist"
			if idPropertyDefinition.type == 'reference'
				throw "INVALID REFERENCE - TYPE : #{ idPropertyDefinition } is not a value or value list as required by #{ key } definition"
			referenced = @resourceFactory.getResource idPropertyDefinition.resource
			if idPropertyDefinition.type == 'value'
				id = @get idPropertyDefinition.idProperty
				return referenced.read id
			if idPropertyDefinition.type == 'valueList'
				idList = @get idPropertyDefinition.idProperty
				if referenced.readList typeof 'undefined'
					return referenced.readList idList
				promiseList = []
				for id in idList
					promiseList.push(referenced.read id)
				return q.all promiseList
		if definition.type == 'value'
			return @read key, definition.idProperty, 'VALUE'
		if definition.type == 'valueList'
			return @read key, definition.idProperty, 'VALUE'
	navigate: (path) ->
		if _.isString path
			path = path.split '/'
		if path.length == 0
			return @
		
		property = path[0]
		definition = @getPropertyDefinition path[0]
		if definition == null
			throw "INVALID PATH - UNKNOWN : #{ path[0] } is an unknown property for #{ @name }"
		if definition.type == 'reference'
			reference = @get property
			if !_.isArray reference
				return reference.navigate path[1..]
			resultList = []
			for resource in reference
				result = resource.navigate path[1..]
				resultList.push result
			return resultList
		if path.length > 1
			throw "INVALID PATH - UNREACHABLE : #{ path[1] } is unreachable because it is specified after a value property"
		#  'value' or 'valueList'
		return @get property
	transform: (object, type = 'OBJECT') ->
		if type == 'OBJECT' || type == null # default type
			return object
		else if type == 'ARRAY'
			return _.values object
		else if type == 'VALUE'
			for value in object
				return object
			throw "EMPTY OBJECT - SINGLE_VALUE: transform can't provide SINGLE_VALUE result for empty object"
		throw "INVALID TYPE PARAM: transform was passed a unknown type param #{ type }"
	
exports.Resource = Resource
