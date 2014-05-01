TestResource = require './sample/TestCrudResourceRead'

describe 'Resource', ->
	r = null
	beforeEach ->
		r = new TestResource
	it ' should return a path ', ->
		expect(r.getPath())
			.toBe 'test-resource'
	it ' should return a property set', ->
		expect(r.getPropertySet())
			.toEqual [
				'propertyA'
				'propertyB'
				'propertyC'
				'propertyD'
				'propertyE'
				'propertyF'
				'propertyG'
				'propertyH'
				'propertyI'
			]
	it ' should return a property definition', ->
		expect(r.getPropertyDefinition 'propertyA')
			.toEqual {type: 'value'}
	it ' should return a property definition', ->
		expect(r.getPropertyDefinition 'propertyD')
			.toEqual {type: 'valueList'}
	it ' should return a property definition', ->
		expect(r.getPropertyDefinition 'propertyF')
			.toEqual {type: 'reference', resource: 'TestResource', idProperty: 'propertyB'}
