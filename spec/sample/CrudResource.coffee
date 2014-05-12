CrudResource = require '../../CrudResource'

class SampleCrudResource extends CrudResource
	name: 'TestResource'
	path: 'test-resource'
	propertyMap: {
		'propertyA':    'value'
		'propertyB':    'value'
		'propertyC':    'valueList'
		'propertyD':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyB'}
		'propertyE':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyC'}
	}
	getIdForObject: (object) ->
		if object.propertyA == 'undefined'
			return null
		return object.propertyA

module.exports = SampleCrudResource
