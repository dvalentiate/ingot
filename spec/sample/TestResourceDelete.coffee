TestResourceRead = require './TestResourceRead'

_ = require 'lodash'
q = require 'q'

class TestResourceDelete extends TestResourceRead
	delete: (id) ->
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

module.exports = TestResourceDelete
