ReferenceImplementationCrudResource = require '../../sample/CrudResource/ReferenceImplementation/CrudResource'
data = require '../../sample/CrudResource/ReferenceImplementation/Data.json'

describe 'CrudResource crudRead', ->
	r = null
	beforeEach ->
		r = new ReferenceImplementationCrudResource
		r.getResourceFactory().addResource r, 'TestResource' # ReferenceImplementationCrudResource set as TestResouce for testing
		r.setData data
	describe ' a value id for a non existent id', ->
		promisedResult = null
		beforeEach (done) ->
			r.crudRead(2).then (result) ->
				promisedResult = result
				done()
		it ' should promise null', (done) ->
			expect(promisedResult).toEqual null
			done()
	describe ' a list of value ids for a non existent ids', ->
		promisedResult = null
		beforeEach (done) ->
			r.crudRead([2, 3]).then (result) ->
				promisedResult = result
				done()
		it ' should promise an empty list', (done) ->
			expect(promisedResult).toEqual []
			done()
	describe ' a list of value ids some are for non existent ids', ->
		promisedResult = null
		beforeEach (done) ->
			r.crudRead([2, 5]).then (result) ->
				promisedResult = result
				done()
		it ' should promise a list with only the valid objects', (done) ->
			expect(promisedResult).toEqual [data['5']]
			done()
	describe ' a value id', ->
		describe ' no propertyList specified', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudRead(1).then (result) ->
					promisedResult = result
					done()
			it ' should promise an object', (done) ->
				expect(promisedResult).toEqual data['1']
				done()
		describe ' a value property', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudRead(1, 'propertyA').then (result) ->
					promisedResult = result
					done()
			it ' should promise a value', (done) ->
				expect(promisedResult).toEqual data['1']['propertyA']
				done()
		describe ' a value list property', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudRead(1, 'propertyC').then (result) ->
					promisedResult = result
					done()
			it ' should promise a value list', (done) ->
				expect(promisedResult).toEqual data['1']['propertyC']
				done()
	describe ' a value id is an object', ->
		describe ' no property specified', ->
			promisedResult = null
			obj = {
				propertyA: 1
				propertyB: 5
				propertyX: [5, 6]
			}
			beforeEach (done) ->
				r.crudRead(obj).then (result) ->
					promisedResult = result
					done()
			it ' should promise an object', (done) ->
				expect(promisedResult).toEqual obj
				done()
		describe ' value property specified', ->
			promisedResult = null
			obj = {
				propertyA: 1
				propertyB: 5
				propertyX: [5, 6]
			}
			beforeEach (done) ->
				r.crudRead(obj, 'propertyA').then (result) ->
					promisedResult = result
					done()
			it ' should promise a value', (done) ->
				expect(promisedResult).toEqual 1
				done()
	describe ' value id is a list', ->
		describe ' no property specified', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudRead([5, 6]).then (result) ->
					promisedResult = result
					done()
			it ' should promise a list of objects matching the resource', (done) ->
				expect(promisedResult).toEqual [data['5'], data['6']]
				done()
		describe ' value property specified', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudRead([5, 6], 'propertyB').then (result) ->
					promisedResult = result
					done()
			it ' should promise a value list', (done) ->
				expect(promisedResult).toEqual [null, 5]
				done()
		describe ' value list property specified', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudRead([5, 6], 'propertyC').then (result) ->
					promisedResult = result
					done()
			it ' should promise a list of value lists', (done) ->
				expect(promisedResult).toEqual [[1], []]
				done()
	describe ' value is a list of objects', ->
		describe ' value property specified', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudRead([data['5'], data['6']], 'propertyB').then (result) ->
					promisedResult = result
					done()
			it ' should promise a list of objects', (done) ->
				expect(promisedResult).toEqual [null, 5]
				done()
