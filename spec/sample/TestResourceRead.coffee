TestResource = require './TestResource'
TestData = require './TestData.json'

_ = require 'lodash'
q = require 'q'

class TestResourceRead extends TestResource
	read: (id, propertyList = null) ->
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
				content = TestData[x + '']
			
			if propertyList != null
				if _.isArray propertyList
					content = @transform content, propertyList
				else
					content = content[propertyList]
			
			result.push content
		defer.resolve if multiple then result else result[0]
		return defer.promise

module.exports = TestResourceRead
