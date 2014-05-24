Resource = require '../../Resource'

class SampleResource extends Resource
	name: 'SampleResource'
	path: 'sample-resource'
	propertyMap: {
		'propertyA':    'value'
		'propertyB':    'value'
		'propertyC':    'valueList'
		'propertyD':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyB'}
		'propertyE':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyC'}
	}

module.exports = SampleResource
