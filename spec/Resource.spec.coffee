Resource = require '../Resource'

describe 'Resource', ->
	r = null
	beforeEach ->
		r = new Resource
		r.getResourceFactory().addResource r
		r.propertyMap = {
			propertyA: 'value'
			propertyB: 'value'
			propertyC: 'valueList'
			propertyD: 'valueList'
			propertyE: {type: 'reference', resource: 'Resource', idProperty: 'propertyA'}
			propertyF: {type: 'reference', resource: 'Resource', idProperty: 'propertyC'}
		}
	it ' should return a property set', ->
		expect(r.getPropertySet()).toEqual [
			'propertyA'
			'propertyB'
			'propertyC'
			'propertyD'
			'propertyE'
			'propertyF'
		]
	it ' should return a property definition', ->
		expect(r.getPropertyDefinition 'propertyA').toEqual {type: 'value'}
		expect(r.getPropertyDefinition 'propertyB').toEqual {type: 'value'}
		expect(r.getPropertyDefinition 'propertyC').toEqual {type: 'valueList'}
		expect(r.getPropertyDefinition 'propertyD').toEqual {type: 'valueList'}
		expect(r.getPropertyDefinition 'propertyE').toEqual {type: 'reference', resource: 'Resource', idProperty: 'propertyA'}
		expect(r.getPropertyDefinition 'propertyF').toEqual {type: 'reference', resource: 'Resource', idProperty: 'propertyC'}
