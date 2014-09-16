CrudResource = require '../../CrudResource'
_ = require 'lodash'
q = require 'q'

class ReferenceImplementationCrudResource extends CrudResource
	data: null
	name: 'SampleCrudResource'
	path: 'sample-crud-resource'
	propertyMap:
		'propertyA':    'value'
		'propertyB':    'value'
		'propertyC':    'valueList'
		'propertyD':    type: 'reference', resource: 'SampleCrudResource', idProperty: 'propertyB'
		'propertyE':    type: 'reference', resource: 'SampleCrudResource', idProperty: 'propertyC'
	access:
		create: [
			matchType: 'boolean', path: '{true}'
		]
		read: [
			matchType: 'boolean', path: '{true}'
		]
		update: [
			matchType: 'boolean', path: '{true}'
		]
		delete: [
			matchType: 'boolean', path: '{true}'
		]
	idProperty: 'propertyA'
	setData: (data) ->
		@data = data
		return @
	crudCreate: (data = null, propertyList = null) ->
		multiple = _.isArray data
		if !multiple
			data = [data]
		id = []
		for x in data
			v = if typeof x[@idProperty] == 'undefined' then null else x[@idProperty]
			if v == null || typeof @data[v + ''] != 'undefined'
				v = Object.keys(@data).reduce (x, y) -> 1 + if +x > +y then +x else +y
			id.push v
			@data[v + ''] = x
		if !multiple
			id = id[0]
		return @crudRead id, propertyList
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
			data = [data]
		
		for x, k in id
			if x == null
				continue
			
			if _.isObject x
				x = x[@idProperty]
			else
				x = x + ''
			
			if typeof @data[x] == 'undefined'
				# id item is referencing an invalid resource, nothing to do
				continue
			
			if typeof data[k][@idProperty] == 'undefined'
				# ensure that data has a id property
				# because of our storage system indexes are string and the id properties are integers
				data[k][@idProperty] = parseInt(x)
			
			if x != data[k][@idProperty] + ''
				# the resource is moving because the id property is different
				id[k] = data[k][@idProperty] + ''
				delete @data[x]
			
			@data[id[k]] = data[k]
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
