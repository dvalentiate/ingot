ReferenceImplementationCrudResource = require '../../sample/CrudResource/ReferenceImplementation/CrudResource'
data = require '../../sample/CrudResource/ReferenceImplementation/Data.json'
_ = require 'lodash'

describe 'CrudResource crudUpdate', ->
	r = null
	beforeEach ->
		r = new ReferenceImplementationCrudResource
		r.getResourceFactory().addResource r, 'SampleCrudResource' # ReferenceImplementationCrudResource set as SampleCrudResource for spec
		r.setData _.cloneDeep data
	describe ' a value', ->
		describe ' for a valid id', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudUpdate(1, _.extend {}, data['1'], {
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
				r.crudUpdate(2, _.extend {}, data['1'], {
					propertyA: 2
					propertyB: 6
				}).then (result) ->
					promisedResult = result
					done()
			it ' should promise null', (done) ->
				expect(promisedResult).toEqual null
				done()
		describe ' for a valid id that is moving', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudUpdate(1, _.extend {}, data['1'], {
					propertyA: 2
				}).then (result) ->
					promisedResult = result
					done()
			it ' should promise a resource with the new id property', (done) ->
				expectedResult = _.cloneDeep data['1']
				expectedResult.propertyA = 2
				expect(promisedResult).toEqual expectedResult
				done()
			it ' should have the resource existing in the new location and not the old', (done) ->
				expect(typeof r.data['2']).toEqual 'object'
				expect(typeof r.data['1']).toEqual 'undefined'
				done()
	describe ' a list of values', ->
		describe ' for valid ids', ->
			promisedResult = null
			beforeEach (done) ->
				r.crudUpdate([1, 5], [
					_.extend {}, data['1'], {
						propertyB: 6
					}
					_.extend {}, data['5'], {
						propertyB: 6
					}
				]).then (result) ->
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
				r.crudUpdate([1, 2], [
					_.extend {}, data['1'], {
						propertyB: 6
					}
					_.extend {}, data['1'], {
						propertyA: 2
						propertyB: 6
					}
				]).then (result) ->
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
				r.crudUpdate([2, 3], [
					_.extend {}, data['1'], {
						propertyA: 2
						propertyB: 6
					}
					_.extend {}, data['1'], {
						propertyA: 3
						propertyB: 6
					}
				]).then (result) ->
					promisedResult = result
					done()
			it ' should promise an empty list', (done) ->
				expect(promisedResult).toEqual []
				done()
