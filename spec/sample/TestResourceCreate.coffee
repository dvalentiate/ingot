TestResource = require './TestResourceRead'
_ = require 'lodash'
q = require 'q'

class TestResourceCreate extends TestResourceRead
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

module.exports = TestResourceCreate
