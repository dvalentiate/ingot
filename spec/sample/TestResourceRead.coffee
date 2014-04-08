TestResource = require './TestResource'
_ = require 'lodash'
q = require 'q'

class TestResourceRead extends TestResource
	read: (id, propertyList = null) ->
		defer = q.defer()
		multiple = _.isArray id
		if !multiple
			id = [id]
		
		exampleData = {
			'1': {
				propertyA: 1
				propertyB: 5
				propertyC: 'X'
				propertyD: [5, 6]
				propertyE: ['X']
			},
			'5': {
				propertyA: 5
				propertyB: null
				propertyC: ''
				propertyD: [1]
				propertyE: []
			},
			'6': {
				propertyA: 6
				propertyB: 5
				propertyC: null
				propertyD: []
				propertyE: []
			},
			'X': {
				propertyA: 'X'
				propertyB: null
				propertyC: null
				propertyD: []
				propertyE: []
			}
		}
		
		result = []
		for x in id
			if x == null
				result.push null
				continue
			
			if _.isObject x
				content = x
			else
				content = exampleData[x + '']
			
			if propertyList != null
				if _.isArray propertyList
					content = @transform content, propertyList
				else
					content = content[propertyList]
			
			result.push content
		defer.resolve if multiple then result else result[0]
		return defer.promise
	create: (data = null, propertyList = null) ->
		defer = q.defer()
		defer.resolve(data)
		return defer.promise
	update: (id, data = null, propertyList = null) ->
		defer = q.defer()
		defer.resolve(id)
		defer.promise.then (result) ->
			return @read result, propertyList
		return defer.promise
	delete: (id) ->
		defer = q.defer()
		defer.resolve()
		return defer.promise

module.exports = TestResourceRead
