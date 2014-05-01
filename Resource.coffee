_ = require 'lodash'
q = require 'q'

# abstract
class Resource
	account: null
	resourceFactory: null
	constructor: ->
	getPath: ->
		return @path
	getPropertySet: ->
		return _.keys @propertyMap
	setAccessContext: (account) ->
		@account = account
		return @
	setResourceFactory: (resourceFactory) ->
		@resourceFactory = resourceFactory
		return @
	getResourceFactory: ->
		if @resourceFactory == null
			@resourceFactory = new (require './ResourceFactory')
			@resourceFactory.addResource @
		return @resourceFactory
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
	getPropertyDefinition: (property) ->
		if not @propertyMap[property]?
			return null
		definition = @propertyMap[property]
		if typeof definition == 'string'
			definition = {type: definition}
		return definition
	navigate: (path, resourceObj) ->
		if _.isString path
			path = path.split '/'
			for x, i in path
				path[i] = path[i].trim()
		path = _.without path, ''
		if path.length == 0
			return @get resourceObj
		property = path[0]
		definition = @getPropertyDefinition path[0]
		if definition == null
			throw "INVALID PATH - UNKNOWN : #{ path[0] } is an unknown property for #{ @name }"
		if definition.type == 'reference'
			resource = @
			return @get(resourceObj, property)
				.then (reference) ->
					referencedResource = resource.getResourceFactory().getResource definition.resource
					if _.isArray reference
						reference = _.unique reference
						reference = _.without reference, null
					return referencedResource.navigate path[1..], reference
		if path.length > 1
			throw "INVALID PATH - UNREACHABLE : #{ path[1] } is unreachable because it is specified after a value property"
		if definition.type == 'valueList' && _.isArray resourceObj
			return @get(resourceObj, property).then (list) ->
				return _.flatten list, true
		# 'value'
		return @get resourceObj, property

module.exports = Resource
