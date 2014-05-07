CrudResource = require '../../CrudResource'

class TestCrudResource extends CrudResource
	name: 'TestResource'
	path: 'test-resource'
	propertyMap: {
		'propertyA':    'value'
		'propertyB':    'value'
		'propertyC':    'value'
		'propertyD':    'valueList'
		'propertyE':    'valueList'
		'propertyF':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyB'}
		'propertyG':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyC'}
		'propertyH':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyD'}
		'propertyI':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyE'}
		'badPropertyA': {type: 'reference', resource: 'TestResource', idProperty: 'propertyM'} # invalid, for testing
		'badPropertyB': {type: 'reference', resource: 'TestResource', idProperty: 'propertyF'} # invalid, for testing
		'badPropertyC': {type: 'reference', resource: 'TestResourceTest', idProperty: 'propertyE'} # invalid, for testing
		'badPropertyD': {type: 'invalidType', resource: 'TestResource', idProperty: 'propertyB'} # invalid, for testing
	}
	access: {
		create: [
			{matchType: 'boolean', path: '{true}'}
		]
		read: [
			{matchType: 'boolean', path: '{true}'}
		]
		update: [
			{matchType: 'boolean', path: '{true}'}
		]
		delete: [
			{matchType: 'boolean', path: '{true}'}
		]
	}
	getIdForObject: (object) ->
		if object.propertyA == 'undefined'
			return null
		return object.propertyA

module.exports = TestCrudResource
