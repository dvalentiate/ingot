test = ->
	describe 'Resource', ->
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
				]
		
		it 'should provide a property definition syncronously', ->
			expect(r.getPropertyDefinition 'propertyA')
				.toEqual {type: 'value'}
		
		it 'should provide a property definition syncronously', ->
			expect(r.getPropertyDefinition 'propertyC')
				.toEqual {type: 'valueList'}
		
		it 'should provide a property definition syncronously', ->
			expect(r.getPropertyDefinition 'propertyE')
				.toEqual {type: 'reference', resource: 'TestResource', idProperty: 'propertyA'}
		
		describe 'when using get with only an id specified', ->
			value = null
			
			beforeEach (done) ->
				r.get(1).then (result) ->
					value = result
					done()
			
			it 'should provide a complete object representing the resource', (done) ->
				expect(value).toEqual {
					propertyA: 1
					propertyB: 'A'
					propertyC: [5, 6, 7]
					propertyD: ['X', 'Y', 'Z']
				}
				done()
		
		describe 'when using get for a value property', ->
			value = null
			
			beforeEach (done) ->
				r.get(1, 'propertyA').then (result) ->
					value = result
					done()
			
			it 'should provide a value', (done) ->
				expect(value).toEqual 1
				done()
		
		describe 'when using get for a string value property', ->
			value = null
			
			beforeEach (done) ->
				r.get(1, 'propertyB').then (result) ->
					value = result
					done()
			
			it 'should provide a string value', (done) ->
				expect(value).toEqual 'A'
				done()
		
		describe 'when using get for a value list property', ->
			value = null
			
			beforeEach (done) ->
				r.get(1, 'propertyC').then (result) ->
					value = result
					done()
			
			it 'should provide a value list', (done) ->
				expect(value).toEqual [5, 6, 7]
				done()
		
		describe 'when using get for a string value list property', ->
			value = null
			
			beforeEach (done) ->
				r.get(1, 'propertyD').then (result) ->
					value = result
					done()
			
			it 'should provide a string value list', (done) ->
				expect(value).toEqual ['X', 'Y', 'Z']
				done()

Resource = require '../Resource'
q = require 'q'

class TestResource extends Resource
	name: 'TestResource'
	path: 'test-resource'
	propertyMap: {
		'propertyA':    'value'
		'propertyB':    'value'
		'propertyC':    'valueList'
		'propertyD':    'valueList'
		'propertyE':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyA'}
		'propertyF':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyB'}
		'propertyG':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyC'}
		'propertyH':    {type: 'reference', resource: 'TestResource', idProperty: 'propertyD'}
	}
	access: {
		create: [
			{matchType: 'boolean', path: '{true}'}
		]
		read: [
			{matchType: 'list', path: '{A}'}
		]
		update: [
			{matchType: 'list', path: '{A}'}
		]
		delete: [
			{matchType: 'list', path: '{A}'}
		]
	}
	read: (id, property = null) ->
		defer = q.defer()
		
		result = {
			'1': {
				propertyA: 1
				propertyB: 'A'
				propertyC: [5, 6, 7]
				propertyD: ['X', 'Y', 'Z']
			}
		}
		
		if property == null
			defer.resolve result[id + '']
		else
			defer.resolve result[id + ''][property]
		
		return defer.promise

test()