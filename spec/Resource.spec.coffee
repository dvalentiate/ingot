TestResource = require './sample/TestResourceRead'

describe 'Resource', ->
	r = null
	beforeEach ->
		r = new TestResource
	it 'should provide a path syncronously ', ->
		expect(r.getPath())
			.toBe 'test-resource'
	it 'should provide a property set syncronously', ->
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
	it 'should provide a property definition syncronously', ->
		expect(r.getPropertyDefinition 'propertyA')
			.toEqual {type: 'value'}
	it 'should provide a property definition syncronously', ->
		expect(r.getPropertyDefinition 'propertyD')
			.toEqual {type: 'valueList'}
	it 'should provide a property definition syncronously', ->
		expect(r.getPropertyDefinition 'propertyF')
			.toEqual {type: 'reference', resource: 'TestResource', idProperty: 'propertyB'}
