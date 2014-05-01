TestCrudResource = require './TestCrudResource'
_ = require 'lodash'
q = require 'q'

class TestCrudResourceRead extends TestCrudResource
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
	data: null
	setData: (data) ->
		@data = data
		return @

module.exports = TestCrudResourceRead