test = ->
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
		describe 'when using get', ->
			describe 'and a value id param', ->
				describe 'and no property specified', ->
					value = null
					beforeEach (done) ->
						r.get(1).then (result) ->
							value = result
							done()
					it 'should provide a promise to a complete object representing the resource', (done) ->
						expect(value).toEqual {
							propertyA: 1
							propertyB: 5
							propertyC: 'X'
							propertyD: [5, 6]
							propertyE: ['X']
						}
						done()
				describe 'and a value property', ->
					value = null
					beforeEach (done) ->
						r.get(1, 'propertyA').then (result) ->
							value = result
							done()
					it 'should provide a promise to a value', (done) ->
						expect(value).toEqual 1
						done()
				describe 'and a string value property', ->
					value = null
					beforeEach (done) ->
						r.get(1, 'propertyC').then (result) ->
							value = result
							done()
					it 'should provide a promise to a string value', (done) ->
						expect(value).toEqual 'X'
						done()
				describe 'and a value list property', ->
					value = null
					beforeEach (done) ->
						r.get(1, 'propertyD').then (result) ->
							value = result
							done()
					it 'should provide a promise to a value list', (done) ->
						expect(value).toEqual [5, 6]
						done()
				describe 'and a string value list property', ->
					value = null
					beforeEach (done) ->
						r.get(1, 'propertyE').then (result) ->
							value = result
							done()
					it 'should provide a promise to a string value list', (done) ->
						expect(value).toEqual ['X']
						done()
				describe 'and a reference with a value id property', ->
					value = null
					beforeEach (done) ->
						r.get(1, 'propertyF').then (result) ->
							value = result
							done()
					it 'should provide a promise to an object', (done) ->
						expect(value).toEqual {
							propertyA: 5
							propertyB: null
							propertyC: []
							propertyD: []
							propertyE: []
						}
						done()
				describe 'and a reference with a string value id property', ->
					value = null
					beforeEach (done) ->
						r.get(1, 'propertyG').then (result) ->
							value = result
							done()
					it 'should provide a promise to an object', (done) ->
						expect(value).toEqual {
							propertyA: 'X'
							propertyB: null
							propertyC: []
							propertyD: []
							propertyE: []
						}
						done()
				describe 'and a list of references, value list id property', ->
					value = null
					beforeEach (done) ->
						r.get(1, 'propertyH').then (result) ->
							value = result
							done()
					it 'should provide a promise to a list of objects', (done) ->
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
				describe 'and a list of references, string value list id property', ->
					value = null
					beforeEach (done) ->
						r.get(1, 'propertyI').then (result) ->
							value = result
							done()
					it 'should provide a promise to a list of objects', (done) ->
						expect(value).toEqual [
							{
								propertyA: 'X'
								propertyB: null
								propertyC: []
								propertyD: []
								propertyE: []
							}
						]
						done()
			describe 'and a value id is an object', ->
				describe 'and no property specified', ->
					value = null
					obj = {
						propertyA: 1
						propertyB: 5
						propertyC: 'X'
						propertyD: [5, 6]
						propertyE: ['X']
					}
					beforeEach (done) ->
						r.get(obj).then (result) ->
							value = result
							done()
					it 'should provide a promise to a complete object representing the resource', (done) ->
						expect(value).toEqual obj
						done()
				describe 'and value property specified', ->
					value = null
					obj = {
						propertyA: 1
						propertyB: 5
						propertyC: 'X'
						propertyD: [5, 6]
						propertyE: ['X']
					}
					beforeEach (done) ->
						r.get(obj, 'propertyA').then (result) ->
							value = result
							done()
					it 'should provide a promise to a value', (done) ->
						expect(value).toEqual 1
						done()
				describe 'and a reference with a value id property', ->
					value = null
					obj = {
						propertyA: 1
						propertyB: 5
						propertyC: 'X'
						propertyD: [5, 6]
						propertyE: ['X']
					}
					beforeEach (done) ->
						r.get(obj, 'propertyF').then (result) ->
							value = result
							done()
					it 'should provide a promise to an object', (done) ->
						expect(value).toEqual {
							propertyA: 5
							propertyB: null
							propertyC: []
							propertyD: []
							propertyE: []
						}
						done()
				describe 'and a list of references, value list id property', ->
					value = null
					obj = {
						propertyA: 1
						propertyB: 5
						propertyC: 'X'
						propertyD: [5, 6]
						propertyE: ['X']
					}
					beforeEach (done) ->
						r.get(obj, 'propertyH').then (result) ->
							value = result
							done()
					it 'should provide a promise to a list of objects', (done) ->
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
		
		describe 'when navigate is called with empty path param', ->
			describe 'and resource object param is a value', ->
				value = null
				beforeEach (done) ->
					r.navigate('', 1).then (result) ->
						value = result
						done()
				it 'should provide a promise to a resource object with a id equalling the param value', (done) ->
					expect(value).toEqual {
						propertyA: 1
						propertyB: 5
						propertyC: 'X'
						propertyD: [5, 6]
						propertyE: ['X']
					}
					done()
			describe 'and resource object param is an object', ->
				value = null
				beforeEach (done) ->
					r.navigate('', {
						propertyA: 1
						propertyB: 5
						propertyC: 'X'
						propertyD: [5, 6]
						propertyE: ['X']
					}).then (result) ->
						value = result
						done()
				it 'should provide a promise to a resource object that was passed in', (done) ->
					expect(value).toEqual {
						propertyA: 1
						propertyB: 5
						propertyC: 'X'
						propertyD: [5, 6]
						propertyE: ['X']
					}
					done()
			describe 'and resource object param is a list of values', ->
				value = null
				beforeEach (done) ->
					r.navigate('', [5, 6]).then (result) ->
						value = result
						done()
				it 'should provide a promise to a list of resource objects with ids equalling those in the resource object param', (done) ->
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
			describe 'and resource object param is a list of objects', ->
				it 'should provide a promise to a list the resource objects that were passed in'
		describe 'when navigate is called with non empty path param', ->
			describe 'and end node names a value property', ->
				describe 'and resource object param is a value', ->
					it 'should provide a promise to a value corresponding to the property of a resource object specified by the resource object param'
				describe 'and resource object param is an object', ->
					it 'should provide a promise to a value corresponding to the property of the passed resource object'
				describe 'and resource object param is a list of values', ->
					it 'should provide a promise to a list of values corresponding to the path property of each of the resource objects specified by the object resource list'
				describe 'and resource object param is a list of objects', ->
					it 'should provide a promise to a list of values corresponding to the path property of each of passed resource objects'
			describe 'and end node names a value list property', ->
				describe 'and resource object param is a value', ->
					it 'should provide a promise to the list values corresponding to the property of a resource object specified by the resource object param'
				describe 'and resource object param is an object', ->
					it 'should provide a promise to the list values corresponding to the property of the passed resource object'
				describe 'and resource object param is a list of values', ->
					it 'should provide a promise to a list of value lists corresponding to the path property of each of the resource objects specified by the object resource list'
				describe 'and resource object param is a list of objects', ->
					it 'should provide a promise to a list of value lists corresponding to the path property of each of passed resource objects'
			describe 'and end node names a reference property', ->
				describe 'and the reference is based on a value id property', ->
					describe 'and resource object is a resource objects', ->
						it 'should provide a promise to a resource object corresponding to the reference\'s id property'
					describe 'and resource object is a list of resource objects', ->
						it 'should provide a promise to a list of resource objects corresponding to the reference\'s id property'
				describe 'and the reference is based on a value list id property', ->
					describe 'and resource object is a resource objects', ->
						it 'should provide a promise to a list of resource objects corresponding to the reference\'s id property'
					describe 'and resource object is a list of resource objects', ->
						it 'should provide a promise to a list of resource objects corresponding to the reference\'s id property'


Resource = require '../Resource'
_ = require 'lodash'
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
	read: (id, propertyList = null) ->
		defer = q.defer()
		if _.isObject(id) && !_.isArray(id)
			id = @transform id, propertyList
			defer.resolve id
			return defer.promise
		
		exampleData = {
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
		
		multiple = _.isArray id
		if !multiple
			id = [id]
		result = []
		for x in id
			result.push @transform exampleData[x + ''], propertyList
		defer.resolve if multiple then result else result[0]
		return defer.promise

test()