TestResource = require './TestResourceRead'
_ = require 'lodash'
q = require 'q'

class TestResourceCreate extends TestResourceRead
	delete: (id) ->
		defer = q.defer()
		defer.resolve()
		return defer.promise

module.exports = TestResourceCreate
