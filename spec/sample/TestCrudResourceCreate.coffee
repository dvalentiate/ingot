TestCrudResourceRead = require './TestCrudResourceRead'
_ = require 'lodash'
q = require 'q'

class TestCrudResourceCreate extends TestCrudResourceRead
	crudCreate: (data = null, propertyList = null) ->
		defer = q.defer()
		defer.resolve(data)
		return defer.promise

module.exports = TestCrudResourceCreate
