ReferenceImplementationCrudResource = require '../../sample/CrudResource/ReferenceImplementation/CrudResource'
data = require '../../sample/CrudResource/ReferenceImplementation/Data.json'
_ = require 'lodash'

describe 'CrudResource crudCreate', ->
	r = null
	beforeEach ->
		r = new ReferenceImplementationCrudResource
		r.getResourceFactory().addResource r, 'TestResource' # ReferenceImplementationCrudResource set as TestResouce for testing
		r.setData _.cloneDeep data
	describe ' a value', ->
		describe ' with a specified but non conflicting id property', ->
			promisedResult = null
			obj = {
				propertyA: 3
				propertyB: 6
				propertyC: [6]
			}
			beforeEach (done) ->
				r.crudCreate(obj).then (result) ->
					promisedResult = result
					done()
			it ' should promise the created resource', (done) ->
				expect(promisedResult).toEqual obj
				done()
			it ' should update data', (done) ->
				expectedResult = _.cloneDeep data
				expectedResult['3'] = obj
				expect(r.data).toEqual expectedResult
				done()
		describe ' with a specified but conflicting id property', ->
			promisedResult = null
			obj = {
				propertyA: 1
				propertyB: 6
				propertyC: [6]
			}
			beforeEach (done) ->
				r.crudCreate(obj).then (result) ->
					promisedResult = result
					done()
			it ' should promise the created resource', (done) ->
				expect(promisedResult).toEqual obj
				done()
			it ' should update data', (done) ->
				expectedResult = _.cloneDeep data
				obj.propertyA = 7
				expectedResult['7'] = obj
				expect(r.data).toEqual expectedResult
				done()
		describe ' with null id property', ->
			promisedResult = null
			obj = {
				propertyA: null
				propertyB: 6
				propertyC: [6]
			}
			beforeEach (done) ->
				r.crudCreate(obj).then (result) ->
					promisedResult = result
					done()
			it ' should promise the created resource', (done) ->
				expect(promisedResult).toEqual obj
				done()
			it ' should update data', (done) ->
				expectedResult = _.cloneDeep data
				obj.propertyA = 7
				expectedResult['7'] = obj
				expect(r.data).toEqual expectedResult
				done()
		describe ' with non specified id property', ->
			promisedResult = null
			obj = {
				propertyB: 6
				propertyC: [6]
			}
			beforeEach (done) ->
				r.crudCreate(obj).then (result) ->
					promisedResult = result
					done()
			it ' should promise the created resource', (done) ->
				expect(promisedResult).toEqual obj
				done()
			it ' should update data', (done) ->
				expectedResult = _.cloneDeep data
				obj.propertyA = 7
				expectedResult['7'] = obj
				expect(r.data).toEqual expectedResult
				done()
