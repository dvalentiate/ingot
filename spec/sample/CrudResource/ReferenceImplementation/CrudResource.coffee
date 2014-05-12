CrudResource = require '../../CrudResource'
_ = require 'lodash'
q = require 'q'

class ReferenceImplementationCrudResource extends CrudResource
	data: null
	name: 'TestResource'
	path: 'test-resource'
	propertyMap: {
		'propertyA':    'value'
		'propertyB':    'value'
		'propertyC':    'valueList'
		'propertyD':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyB'}
		'propertyE':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyC'}
	}
	access: {
		create: [
			{matchType: 'boolean', path: '{true}'}
		]
		read: [
			{matchType: 'boolean', path: '{true}'}
		]
		update: [
			{matchType: 'boolean', path: '{true}'}
		]
		delete: [
			{matchType: 'boolean', path: '{true}'}
		]
	}
	getIdForObject: (object) ->
		if object.propertyA == 'undefined'
			return null
		return object.propertyA
	setData: (data) ->
		@data = data
		return @
	crudCreate: (data = null, propertyList = null) ->
		defer = q.defer()
		defer.resolve(data)
		return defer.promise
	crudRead: (id, propertyList = null) ->
		defer = q.defer()
		multiple = _.isArray id
		if !multiple
			id = [id]
		
		result = []
		for x in id
			if x == null
				result.push null
				continue
			
			if _.isObject x
				content = x
			else
				content = @data[x + '']
			
			if typeof content == 'undefined'
				continue
			
			if propertyList != null
				if _.isArray propertyList
					content = _.pick content, propertyList
				else
					content = content[propertyList]
			
			result.push content
		defer.resolve if multiple then result else result[0]
		return defer.promise
	crudUpdate: (id, data = null, propertyList = null) ->
		
		# implement logic to alter the test data
		multiple = _.isArray id
		if !multiple
			id = [id]
		
		for x in id
			if x == null
				continue
			
			if _.isObject x
				x = @getIdForObject x
			else
				x = x + ''
			
			@data[x] = _.extend @data[x], data
		if !multiple
			id = id[0]
		
		return @crudRead id, propertyList
	crudDelete: (id) ->
		defer = q.defer()
		result = []
		
		multiple = _.isArray id
		if !multiple
			id = [id]
		
		for x in id
			index = x + ''
			valid = typeof @data[index] != 'undefined'
			if valid
				delete @data[index]
				result.push x
		defer.resolve if multiple then result else if result.length > 0 then result[0] else null
		
		return defer.promise

module.exports = ReferenceImplementationCrudResource
