TestCrudResourceRead = require './TestCrudResourceRead'
_ = require 'lodash'
q = require 'q'

class TestCrudResourceUpdate extends TestCrudResourceRead
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

module.exports = TestCrudResourceUpdate
