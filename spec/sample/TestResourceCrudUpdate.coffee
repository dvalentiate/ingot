TestResourceCrudRead = require './TestResourceCrudRead'

_ = require 'lodash'
q = require 'q'

class TestResourceCrudUpdate extends TestResourceCrudRead
	crudUpdate: (id, data = null, propertyList = null) ->
		return @crudRead id, propertyList

module.exports = TestResourceCrudUpdate
