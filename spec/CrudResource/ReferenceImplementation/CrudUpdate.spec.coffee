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
				r.crudUpdate(1, {
					propertyB: 6
				}).then (result) ->
					promisedResult = result
					done()
			it ' should promise the updated id', (done) ->
				expectedResult = _.cloneDeep data['1']
				expectedResult.propertyB = 6
				expect(promisedResult).toEqual expectedResult
				done()
			it ' should update data', (done) ->
				expectedResult = _.cloneDeep data
				expectedResult['1'].propertyB = 6
				expect(r.data).toEqual expectedResult
				done()
		describe ' for an invalid id', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudUpdate(2, {
					propertyB: 6
				}).then (result) ->
					promisedResult = result
					done()
			it ' should promise null', (done) ->
				expect(promisedResult).toEqual null
				done()
	describe ' a list of values', ->
		describe ' for valid ids', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudUpdate([1, 5], {
					propertyB: 6
				}).then (result) ->
					promisedResult = result
					done()
			it ' should promise a list of updated resources', (done) ->
				expectedResult = [
					_.cloneDeep data['1']
					_.cloneDeep data['5']
				]
				expectedResult[0].propertyB = 6
				expectedResult[1].propertyB = 6
				expect(promisedResult).toEqual expectedResult
				done()
		describe ' for some valid ids', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudUpdate([1, 2], {
					propertyB: 6
				}).then (result) ->
					promisedResult = result
					done()
			it ' should promise a list of a single updated resource', (done) ->
				expectedResult = [_.cloneDeep data['1']]
				expectedResult[0].propertyB = 6
				expect(promisedResult).toEqual expectedResult
				done()
		describe ' for no valid ids', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudUpdate([2, 3], {
					propertyB: 6
				}).then (result) ->
					promisedResult = result
					done()
			xit ' should promise an empty list', (done) ->
				expect(promisedResult).toEqual []
				done()
