SampleCrudResource = require '../sample/CrudResource'
q = require 'q'

describe 'Resource post', ->
	r = null
	beforeEach ->
		r = new SampleCrudResource
		r.getResourceFactory().addResource r
	describe ' calls crudCreate and it is working great with the provided params', ->
		promisedResult = null
		beforeEach (done) ->
			spyOn(r, 'crudCreate').andCallFake (data = null, propertyList = null) ->
				defer = q.defer()
				defer.resolve 'crud create result'
				return defer.promise
			r.post({'propertyB': 7}).then (result) ->
				promisedResult = result
				done()
		it ' should crudCreate and return a promised value', (done) ->
			expect(r.crudCreate.callCount).toEqual 1
			expect(r.crudCreate.mostRecentCall.args).toEqual [{'propertyB': 7}, null]
			expect(promisedResult).toEqual 'crud create result'
			done()
	describe ' crudCreate is throwing errors', ->
		rejectReason = null
		beforeEach (done) ->
			spyOn(r, 'crudCreate').andThrow 'crudCreate problem'
			r.post('id param', {'propertyA': 7}).then null, (reason) ->
				rejectReason = reason
				done()
		it ' should call crudCreate and return a promised value', (done) ->
			expect(r.crudCreate.callCount).toEqual 1
			expect(rejectReason).toEqual 'crudCreate problem'
			done()
