SampleCrudResource = require '../sample/CrudResource'
q = require 'q'

describe 'Resource put', ->
	r = null
	beforeEach ->
		r = new SampleCrudResource
		r.getResourceFactory().addResource r
	describe ' calls crudCreate, crudRead, crudUpdate, and they are working great with the provided params', ->
		promisedResult = null
		beforeEach ->
			spyOn(r, 'crudCreate').andCallFake (data = null, propertyList = null) ->
				defer = q.defer()
				defer.resolve ['crud create result']
				return defer.promise
			spyOn(r, 'crudRead').andCallFake (id = null, propertyList = null) ->
				defer = q.defer()
				if id.length == 1 && id[0] == 'id param'
					defer.resolve [{'propertyA': 'id param'}]
				else if id == ['array id param 1', 'array id param 2', 'array id param 3']
					defer.resolve ['array id param 2']
				else
					defer.resolve []
				return defer.promise
			spyOn(r, 'crudUpdate').andCallFake (id, data = null, propertyList = null) ->
				defer = q.defer()
				defer.resolve ['crud update result']
				return defer.promise
		describe ' id param does not match an existing id', ->
			beforeEach (done) ->
				r.put('new id param', {'propertyA': 7}).then (result) ->
					promisedResult = result
					done()
			it ' should call crudRead and then crudCreate and return a promised value', (done) ->
				expect(r.crudRead.callCount).toEqual 1
				expect(r.crudRead.mostRecentCall.args).toEqual [['new id param'], null]
				expect(r.crudUpdate.callCount).toEqual 0
				expect(r.crudCreate.callCount).toEqual 1
				expect(r.crudCreate.mostRecentCall.args).toEqual [['new id param'], [{propertyA : 7}]]
				expect(promisedResult).toEqual 'crud create result'
				done()
		describe ' id param matches an existing id', ->
			beforeEach (done) ->
				r.put('id param', {'propertyA': 7}).then (result) ->
					promisedResult = result
					done()
			it ' should call crudRead and then crudUpdate and return a promised value', (done) ->
				expect(r.crudRead.callCount).toEqual 1
				expect(r.crudRead.mostRecentCall.args).toEqual [['id param'], null]
				expect(r.crudUpdate.callCount).toEqual 1
				expect(r.crudUpdate.mostRecentCall.args).toEqual [['id param'], [{'propertyA': 7}], null]
				expect(r.crudCreate.callCount).toEqual 0
				expect(promisedResult).toEqual 'crud update result'
				done()
	describe ' crudRead is throwing errors', ->
		rejectReason = null
		beforeEach (done) ->
			spyOn(r, 'crudRead').andThrow 'crudRead problem'
			r.put('id param', {'propertyA': 7}).then null, (reason) ->
				rejectReason = reason
				done()
		it ' should call crudRead and then crudUpdate and return a promised value', (done) ->
			expect(r.crudRead.callCount).toEqual 1
			expect(rejectReason).toEqual 'crudRead problem'
			done()
	describe ' crudCreate and crudUpdate are throwing errors', ->
		rejectReason = null
		beforeEach ->
			spyOn(r, 'crudCreate').andThrow 'crudCreate problem'
			spyOn(r, 'crudRead').andCallFake (id = null, propertyList = null) ->
				defer = q.defer()
				if id.length == 1 && id[0] == 'id param'
					defer.resolve [{'propertyA': 'id param'}]
				else if id == ['array id param 1', 'array id param 2', 'array id param 3']
					defer.resolve ['array id param 2']
				else
					defer.resolve []
				return defer.promise
			spyOn(r, 'crudUpdate').andThrow 'crudUpdate problem'
		describe ' put on a new id', ->
			beforeEach (done) ->
				r.put('new id param', {'propertyA': 7}).then null, (reason) ->
					rejectReason = reason
					done()
			it ' should call crudRead and then crudCreate on which it will fail', (done) ->
				expect(r.crudRead.callCount).toEqual 1
				expect(r.crudCreate.callCount).toEqual 1
				expect(r.crudUpdate.callCount).toEqual 0
				expect(rejectReason).toEqual 'crudCreate problem'
				done()
		describe ' put on an existing id', ->
			beforeEach (done) ->
				r.put('id param', {'propertyA': 7}).then null, (reason) ->
					rejectReason = reason
					done()
			it ' should call crudRead and then crudUpdate on which it will fail', (done) ->
				expect(r.crudRead.callCount).toEqual 1
				expect(r.crudCreate.callCount).toEqual 0
				expect(r.crudUpdate.callCount).toEqual 1
				expect(rejectReason).toEqual 'crudUpdate problem'
				done()
