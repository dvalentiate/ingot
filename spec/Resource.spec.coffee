TestResource = require './sample/TestResource'

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
			]
	it ' should return a property definition', ->
		expect(r.getPropertyDefinition 'propertyB')
			.toEqual {type: 'value'}
	it ' should return a property definition', ->
		expect(r.getPropertyDefinition 'propertyC')
			.toEqual {type: 'valueList'}
	it ' should return a property definition', ->
		expect(r.getPropertyDefinition 'propertyD')
			.toEqual {type: 'reference', resource: 'TestResource', idProperty: 'propertyB'}
	it ' should return a property definition', ->
		expect(r.getPropertyDefinition 'propertyE')
			.toEqual {type: 'reference', resource: 'TestResource', idProperty: 'propertyC'}
