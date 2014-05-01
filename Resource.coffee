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

module.exports = Resource
