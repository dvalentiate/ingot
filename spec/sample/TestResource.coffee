Resource = require '../../Resource'

class TestResource extends Resource
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

module.exports = TestResource
