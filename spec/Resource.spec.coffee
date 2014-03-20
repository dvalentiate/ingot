test = ->
	describe 'Resource', ->
		r = new TestResource
		
		it 'provides a path syncronously ', ->
			expect(r.getPath()).toBe 'test-resource'
		
		it 'provides a property set syncronously', ->
			expect(r.getPropertySet()).toEqual([
				'propertyA'
				'propertyB'
				'propertyC'
			])


Resource = require '../Resource'
q = require 'q'

class TestResource extends Resource
	name: 'TestResource'
	path: 'test-resource'
	propertyMap: {
		'propertyA':    'value'
		'propertyB':    'value'
		'propertyC':    'value'
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
	read: (id, propertyList = null, resultType = null) ->
		defer = q.defer()
		
		result = {
			propertyA: 'A'
			propertyB: 'B'
			propertyC: 'C'
		}
		
		process.nextTick ->
			defer.resolve result
		
		return defer.promise

test()