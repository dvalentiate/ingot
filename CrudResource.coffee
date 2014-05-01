Resource = require './Resource'
_ = require 'lodash'
q = require 'q'

# abstract
class CrudResource extends Resource
	get: (id, propertyList = null) ->
		if propertyList == null
			return @crudRead id
		if _.isArray propertyList
			throw "get method doesn't support array of properties ... yet"
		definition = @getPropertyDefinition propertyList
		if definition == null
			throw "INVALID PROPERTY - UNKNOWN : #{ propertyList } is not a propertyList of #{ @name }"
		if definition.type == 'reference'
			referenceIdDefinition = @getPropertyDefinition definition.idProperty
			if referenceIdDefinition == null
				throw "INVALID REFERENCE - UNKNOWN PROPERTY : #{ referenceIdDefinition } referenced by #{ propertyList } definition but doesn't exist"
			if referenceIdDefinition.type == 'reference'
				throw "INVALID REFERENCE - TYPE : #{ referenceIdDefinition } is not a value or value list as required by #{ propertyList } definition"
			referencedResource = @getResourceFactory().getResource definition.resource
			if referencedResource == null
				throw "INVALID REFERENCE - RESOURCE : #{ definition.resource } was not provided by the resource factory"
			if referenceIdDefinition.type == 'value'
				return @get(id, definition.idProperty).then (referencedId) ->
					return referencedResource.crudRead referencedId
			if referenceIdDefinition.type == 'valueList'
				return @get(id, definition.idProperty)
					.then (referencedIdList) ->
						promiseList = []
						for referencedId in referencedIdList
							promiseList.push referencedResource.crudRead referencedId
						return q.all promiseList
					.then (referencedObjectList) ->
						return _.flatten referencedObjectList, true
		if definition.type == 'value'
			return @crudRead id, propertyList
		if definition.type == 'valueList'
			return @crudRead id, propertyList
		throw "INVALID PROPERTY - TYPE : #{ definition.type } is not a recognized propertyList type"
	post: (data = null, propertyList = null) ->
	put: (id, data = null, propertyList = null) ->
		defer = q.defer()
		multiple = _.isArray id
		if !multiple
			id = [id]
		
		result = []
		
		resource = @
		
		# determine which of the id's require CRUD update vs CRUD create
		@crudRead(id).then (readResult) ->
			resultIdList = []
			resultIdList.push resource.getIdForObject x for x in readResult
			
			deferList = []
			
			updateIdList = _.intersection id, resultIdList
			if updateIdList.length > 0
				updateDefer = resource.crudUpdate(updateIdList, data, propertyList).then (updateResult) ->
					result = _.union result, updateResult
				deferList.push updateDefer
			
			createIdList = _.difference id, resultIdList
			if createIdList.length > 0
				createDefer = resource.crudCreate(createIdList, data, propertyList).then (createResult) ->
					result = _.union result, createResult
				deferList.push createDefer
			
			q.all(deferList).then () ->
				defer.resolve if multiple then result else result[0]
		return defer.promise
	delete: (id) ->
		return @crudDelete id

module.exports = CrudResource
