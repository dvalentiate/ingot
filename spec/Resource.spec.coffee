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
		
		describe 'when using get with only an id specified', ->
			value = null
			
			beforeEach (done) ->
				r.get(1).then (result) ->
					value = result
					done()
			
			it 'should provide a complete object representing the resource', (done) ->
				expect(value).toEqual {
					propertyA: 1
					propertyB: 5
					propertyC: 'X'
					propertyD: [5, 6]
					propertyE: ['X']
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
				r.get(1, 'propertyC').then (result) ->
					value = result
					done()
			
			it 'should provide a string value', (done) ->
				expect(value).toEqual 'X'
				done()
		
		describe 'when using get for a value list property', ->
			value = null
			
			beforeEach (done) ->
				r.get(1, 'propertyD').then (result) ->
					value = result
					done()
			
			it 'should provide a value list', (done) ->
				expect(value).toEqual [5, 6]
				done()
		
		describe 'when using get for a string value list property', ->
			value = null
			
			beforeEach (done) ->
				r.get(1, 'propertyE').then (result) ->
					value = result
					done()
			
			it 'should provide a string value list', (done) ->
				expect(value).toEqual ['X']
				done()
		
		describe 'when using get for a reference with a value id property', ->
			value = null
			
			beforeEach (done) ->
				r.get(1, 'propertyF').then (result) ->
					value = result
					done()
			
			it 'should provide an object', (done) ->
				expect(value).toEqual {
					propertyA: 5
					propertyB: null
					propertyC: []
					propertyD: []
					propertyE: []
				}
				done()
		
		describe 'when using get for a reference with a string value id property', ->
			value = null
			
			beforeEach (done) ->
				r.get(1, 'propertyG').then (result) ->
					value = result
					done()
			
			it 'should provide an object', (done) ->
				expect(value).toEqual {
					propertyA: 'X'
					propertyB: null
					propertyC: []
					propertyD: []
					propertyE: []
				}
				done()
		
		describe 'when using get for a list of references, value list id property', ->
			value = null
			
			beforeEach (done) ->
				r.get(1, 'propertyH').then (result) ->
					value = result
					done()
			
			it 'should provide a list of objects', (done) ->
				expect(value).toEqual [
					{
						propertyA: 5
						propertyB: null
						propertyC: []
						propertyD: []
						propertyE: []
					},
					{
						propertyA: 6
						propertyB: null
						propertyC: []
						propertyD: []
						propertyE: []
					}
				]
				done()


Resource = require '../Resource'
q = require 'q'

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
				propertyB: 5
				propertyC: 'X'
				propertyD: [5, 6]
				propertyE: ['X']
			},
			'5': {
				propertyA: 5
				propertyB: null
				propertyC: []
				propertyD: []
				propertyE: []
			},
			'6': {
				propertyA: 6
				propertyB: null
				propertyC: []
				propertyD: []
				propertyE: []
			},
			'X': {
				propertyA: 'X'
				propertyB: null
				propertyC: []
				propertyD: []
				propertyE: []
			}
		}
		
		if property == null
			defer.resolve result[id + '']
		else
			defer.resolve result[id + ''][property]
		
		return defer.promise

test()