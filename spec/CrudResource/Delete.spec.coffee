SampleCrudResource = require '../sample/CrudResource'
q = require 'q'

describe 'Resource delete', ->
	r = null
	beforeEach ->
		r = new SampleCrudResource
		r.getResourceFactory().addResource r, 'TestResource' # added as TestResource for testing
	describe ' a value', ->
		describe ' for a valid id', ->
			promisedResult = null
			beforeEach (done) ->
				spyOn(r, 'crudDelete').andCallFake (id, propertyList = null) ->
					defer = q.defer()
					defer.resolve 'crud delete result'
					return defer.promise
				r.delete('id param').then (result) ->
					promisedResult = result
					done()
			it ' should call crudDelete with id param of delete and return crudDelete\'s promised value', (done) ->
				expect(r.crudDelete.callCount).toEqual 1
				expect(r.crudDelete.mostRecentCall.args).toEqual ['id param']
				expect(promisedResult).toEqual 'crud delete result'
				done()
		describe ' for an invalid id', ->
			promisedResult = null
			rejectReason = null
			beforeEach (done) ->
				spyOn(r, 'crudDelete').andThrow 'exception'
				r.delete('id param').then null, (reason) ->
					rejectReason = reason
					done()
			it ' should call crudDelete with id param of get and return crudDelete\'s reject reason', (done) ->
				expect(rejectReason).toEqual 'exception'
				done()
