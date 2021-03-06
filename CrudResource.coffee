Resource = require './Resource'
_ = require 'lodash'
q = require 'q'
util = require './util'

# abstract
class CrudResource extends Resource
	get: (id, propertyList = null) ->
		if propertyList == null
			return @safeCrudRead id
		if _.isArray propertyList
			return util.reject "get method doesn't support array of properties ... yet"
		definition = @getPropertyDefinition propertyList
		if definition == null
			return util.reject "INVALID PROPERTY - UNKNOWN : #{ propertyList } is not a propertyList of #{ @name }"
		if definition.type == 'reference'
			referenceIdDefinition = @getPropertyDefinition definition.idProperty
			if referenceIdDefinition == null
				return util.reject "INVALID REFERENCE - UNKNOWN PROPERTY : #{ definition.idProperty } referenced by #{ propertyList } definition but doesn't exist"
			if referenceIdDefinition.type == 'reference'
				return util.reject "INVALID REFERENCE - TYPE : #{ definition.idProperty } is not a value or value list as required by #{ propertyList } definition"
			referencedResource = @getResourceFactory().getResource definition.resource
			if referencedResource == null
				return util.reject "INVALID REFERENCE - RESOURCE : #{ definition.resource } was not provided by the resource factory"
			if referenceIdDefinition.type == 'value'
				return @get(id, definition.idProperty).then (referencedId) ->
					return referencedResource.safeCrudRead referencedId
			if referenceIdDefinition.type == 'valueList'
				return @get(id, definition.idProperty)
					.then (referencedIdList) ->
						promiseList = []
						for referencedId in referencedIdList
							promiseList.push referencedResource.safeCrudRead referencedId
						return q.all promiseList
					.then (referencedObjectList) ->
						return _.flatten referencedObjectList, true
		if definition.type == 'value'
			return @safeCrudRead id, propertyList
		if definition.type == 'valueList'
			return @safeCrudRead id, propertyList
		return util.reject "INVALID PROPERTY - TYPE : #{ definition.type } is not a recognized propertyList type"
	post: (data = null, propertyList = null) ->
		return @safeCrudCreate data, propertyList
	put: (id, data = null, propertyList = null) ->
		defer = q.defer()
		multiple = _.isArray id
		if !multiple
			id = [id]
			data = [data]
		
		result = []
		
		resource = @
		
		# determine which of the id's require CRUD update vs CRUD create
		@safeCrudRead(id).then (readResult) ->
			resultIdList = []
			resultIdList.push x[resource.idProperty] for x in readResult
			
			deferList = []
			
			updateIdList = _.intersection id, resultIdList
			if updateIdList.length > 0
				updateDefer = resource.safeCrudUpdate(updateIdList, data, propertyList).then (updateResult) ->
					result = _.union result, updateResult
				deferList.push updateDefer
			
			createIdList = _.difference id, resultIdList
			if createIdList.length > 0
				createDefer = resource.safeCrudCreate(createIdList, data, propertyList).then (createResult) ->
					result = _.union result, createResult
				deferList.push createDefer
			
			q.all(deferList).then ->
				defer.resolve if multiple then result else if result.length > 0 then result[0] else null
			, (reason) ->
				defer.reject reason
		, (reason) ->
			defer.reject reason
		return defer.promise
	delete: (id) ->
		return @safeCrudDelete id
	safeCrudCreate: (data = null, propertyList = null) ->
		try
			return @crudCreate data, propertyList
		catch exception
			return util.reject exception
	safeCrudRead: (id, propertyList = null) ->
		try
			return @crudRead id, propertyList
		catch exception
			return util.reject exception
	safeCrudUpdate: (id, data = null, propertyList = null) ->
		try
			return @crudUpdate id, data, propertyList
		catch exception
			return util.reject exception
	safeCrudDelete: (id) ->
		try
			return @crudDelete id
		catch exception
			return util.reject exception
	crudCreate: (data = null, propertyList = null) ->
	crudRead: (id, propertyList = null) ->
	crudUpdate: (id, data = null, propertyList = null) ->
	crudDelete: (id) ->

module.exports = CrudResource
