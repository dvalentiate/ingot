TestResourceCrudRead = require './TestResourceCrudRead'

_ = require 'lodash'
q = require 'q'

class TestResourceCrudCreate extends TestResourceCrudRead
	create: (data = null, propertyList = null) ->
		defer = q.defer()
		defer.resolve(data)
		return defer.promise

module.exports = TestResourceCrudCreate
