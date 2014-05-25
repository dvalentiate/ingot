SampleCrudResource = require '../sample/CrudResource'
q = require 'q'

describe 'Resource put', ->
	r = null
	beforeEach ->
		r = new SampleCrudResource
		r.getResourceFactory().addResource r
	describe ' no propertyList is specified', ->
		describe ' id is nominal', ->
			describe ' data is nominal', ->
				promisedResult = null
				rejectReason = null
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
				describe ' id param matches an existing id', ->
					beforeEach (done) ->
						r.put('id param', {'propertyA': 7}).then (result) ->
							promisedResult = result
							done()
					it ' should call crudRead and then crudUpdate and return a promised value', (done) ->
						expect(r.crudRead.callCount).toEqual 1
						expect(r.crudRead.mostRecentCall.args).toEqual [['id param'], null]
						expect(r.crudUpdate.callCount).toEqual 1
						expect(r.crudUpdate.mostRecentCall.args).toEqual [['id param'], {'propertyA': 7}, null]
						expect(r.crudCreate.callCount).toEqual 0
						expect(promisedResult).toEqual 'crud update result'
						done()
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
						expect(r.crudCreate.mostRecentCall.args).toEqual [['new id param'], {propertyA : 7}]
						expect(promisedResult).toEqual 'crud create result'
						done()