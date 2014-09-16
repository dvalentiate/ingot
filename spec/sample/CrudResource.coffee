CrudResource = require '../../CrudResource'

class SampleCrudResource extends CrudResource
	name: 'SampleCrudResource'
	path: 'same-crud-resource'
	propertyMap:
		'propertyA':    'value'
		'propertyB':    'value'
		'propertyC':    'valueList'
		'propertyD':    type: 'reference', resource: 'SampleCrudResource', idProperty: 'propertyB'
		'propertyE':    type: 'reference', resource: 'SampleCrudResource', idProperty: 'propertyC'
	idProperty: 'propertyA'

module.exports = SampleCrudResource
