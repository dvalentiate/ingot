Resource = require '../../Resource'

class TestResource extends Resource
	name: 'TestResource'
	path: 'test-resource'
	propertyMap: {
		'propertyA':    'value'
		'propertyB':    'value'
		'propertyC':    'valueList'
		'propertyD':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyB'}
		'propertyE':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyC'}
	}

module.exports = TestResource
