ReferenceImplementationCrudResource = require '../../sample/CrudResource/ReferenceImplementation/CrudResource'
data = require '../../sample/CrudResource/ReferenceImplementation/Data.json'
_ = require 'lodash'

describe 'CrudResource crudDelete', ->
	r = null
	beforeEach ->
		r = new ReferenceImplementationCrudResource
		r.getResourceFactory().addResource r, 'TestResource' # ReferenceImplementationCrudResource set as TestResouce for testing
		r.setData _.cloneDeep data
	describe ' a value', ->
		describe ' for a valid id', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudDelete(1).then (result) ->
					promisedResult = result
					done()
			it ' should promise the deleted id', (done) ->
				expect(promisedResult).toEqual 1
				done()
			it ' should mean that the resource is no longer available', (done) ->
				r.get(1).then (result) ->
					expect(result).toEqual null
					done()
			it ' should mean that the other resources are not affected', (done) ->
				r.get([5, 6]).then (result) ->
					expect(result).toEqual [data['5'], data['6']]
					done()
		describe ' for an invalid id', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudDelete(2).then (result) ->
					promisedResult = result
					done()
			it ' should promise null', (done) ->
				expect(promisedResult).toEqual null
				done()
			it ' should mean that the other resources are not affected', (done) ->
				r.get([1, 5, 6]).then (result) ->
					expect(result).toEqual [data['1'], data['5'], data['6']]
					done()
	describe ' a list of values', ->
		describe ' for valid ids', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudDelete([1, 5]).then (result) ->
					promisedResult = result
					done()
			it ' should promise a list of ids', (done) ->
				expect(promisedResult).toEqual [1, 5]
				done()
		describe ' for some valid ids', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudDelete([1, 2]).then (result) ->
					promisedResult = result
					done()
			it ' should promise a success list of ids', (done) ->
				expect(promisedResult).toEqual [1]
				done()
		describe ' for no valid ids', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudDelete([2, 3]).then (result) ->
					promisedResult = result
					done()
			it ' should promise an empty list', (done) ->
				expect(promisedResult).toEqual []
				done()
