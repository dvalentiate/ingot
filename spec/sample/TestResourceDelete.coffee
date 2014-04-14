TestResource = require './TestResourceRead'
testData = require './TestData.json'

_ = require 'lodash'
q = require 'q'

class TestResourceDelete extends TestResourceRead
	delete: (id) ->
		defer = q.defer()
		result = {}
		
		multiple = _.isArray id
		if !multiple
			id = [id]
		
		for x in id
			index = x + ''
			valid = typeof testData[index] != 'undefined'
			if valid
				delete testData[index]
			if !multiple
				defer.resolve valid
				return
			result[index] = valid
		defer.resolve result
		
		return defer.promise

module.exports = TestResourceDelete
