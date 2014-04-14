TestResourceRead = require './TestResourceRead'

_ = require 'lodash'
q = require 'q'

class TestResourceUpdate extends TestResourceRead
	update: (id, data = null, propertyList = null) ->
		defer = q.defer()
		defer.resolve(id)
		defer.promise.then (result) ->
			return @read result, propertyList
		return defer.promise

module.exports = TestResourceUpdate
