TestResourceRead = require './TestResourceRead'

_ = require 'lodash'
q = require 'q'

class TestResourceCreate extends TestResourceRead
	create: (data = null, propertyList = null) ->
		defer = q.defer()
		defer.resolve(data)
		return defer.promise

module.exports = TestResourceCreate
