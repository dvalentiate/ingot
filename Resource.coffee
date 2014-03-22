_ = require 'lodash'
q = require 'q'

# abstract
class Resource
	account: null
	resourceFactory: null
	constructor: ->
	getPath: ->
		@path
	getPropertySet: ->
		_.keys @propertyMap
	setAccessContext: (account) ->
		@account = account
		@
	setResourceFactory: (resourceFactory) ->
		@resourceFactory = resourceFactory
		@
	getResourceFactory: ->
		if @resourceFactory == null
			@resourceFactory = new (require './ResourceFactory')
			@resourceFactory.addResource @
		@resourceFactory
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
	get: (id, property = null) ->
		if property == null
			return @read id
		if _.isArray property
			throw "get method doesn't support array of properties ... yet"
		definition = @getPropertyDefinition property
		if definition == null
			throw "INVALID PROPERTY - UNKNOWN : #{ property } is not a property of #{ @name }"
		if definition.type == 'reference'
			referenceIdDefinition = @getPropertyDefinition definition.idProperty
			if referenceIdDefinition == null
				throw "INVALID REFERENCE - UNKNOWN PROPERTY : #{ referenceIdDefinition } referenced by #{ property } definition but doesn't exist"
			if referenceIdDefinition.type == 'reference'
				throw "INVALID REFERENCE - TYPE : #{ referenceIdDefinition } is not a value or value list as required by #{ property } definition"
			referencedResource = @getResourceFactory().getResource definition.resource
			if referencedResource == null
				throw "INVALID REFERENCE - RESOURCE : #{ definition.resource } was not provided by the resource factory"
			if referenceIdDefinition.type == 'value'
				referencedId = @get id, definition.idProperty
				return referencedResource.read referencedId
			if referenceIdDefinition.type == 'valueList'
				referencedIdList = @get definition.idProperty
				if referencedResource.readList typeof 'undefined'
					return referencedResource.readList referencedIdList
				promiseList = []
				for referencedId in referencedIdList
					promiseList.push referencedResource.read referencedId
				return q.all promiseList
		if definition.type == 'value'
			return @read id, property
		if definition.type == 'valueList'
			return @read id, property
		throw "INVALID PROPERTY - TYPE : #{ definition.type } is not a recognized property type"
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
	
module.exports = Resource
