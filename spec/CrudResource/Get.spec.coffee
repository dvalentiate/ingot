TestResource = require '../sample/TestCrudResourceRead'
testData = require '../sample/TestData.json'
q = require 'q'

describe 'Resource get', ->
	r = null
	beforeEach ->
		r = new TestResource
		# TestResource is really TestCrudResourceRead, but not for testing
		r.getResourceFactory().addResource r, 'TestResource'
		r.setData testData
	describe ' no propertyList is specified', ->
		describe ' crudRead is nominal', ->
			promisedResult = null
			promise = null
			beforeEach (done) ->
				spyOn(r, 'crudRead').andCallFake (id, propertyList = null) ->
					defer = q.defer()
					defer.resolve 'crud read result'
					return defer.promise
				r.get('id param').then (result) ->
					promisedResult = result
					done()
			it ' should call crudRead with id param of get and return crudRead promised value', (done) ->
				expect(r.crudRead.callCount).toEqual 1
				expect(r.crudRead.mostRecentCall.args).toEqual ['id param', null]
				expect(promisedResult).toEqual 'crud read result'
				done()
		describe ' crudRead throws expection', ->
			promisedResult = null
			rejectReason = null
			beforeEach (done) ->
				spyOn(r, 'crudRead').andThrow 'exception'
				r.get('id param').then null, (reason) ->
					rejectReason = reason
					done()
			it ' should call crudRead with id param of get and return crudRead promised value', (done) ->
				expect(rejectReason).toEqual 'exception'
				done()
		describe ' crudRead returns a rejected promise', ->
			promisedResult = null
			rejectReason = null
			beforeEach (done) ->
				spyOn(r, 'crudRead').andCallFake (id, propertyList = null) ->
					defer = q.defer()
					defer.reject 'rejected'
					return defer.promise
				r.get('id param').then null, (reason) ->
					rejectReason = reason
					done()
			it ' should call crudRead with id param of get and return crudRead promised value', (done) ->
				expect(rejectReason).toEqual 'rejected'
				done()
	describe ' propertyList is an array', ->
		promisedReason = null
		beforeEach (done) ->
			spyOn(r, 'crudRead').andReturn null
			r.get('id param', []).then null, (reason) ->
				promisedReason = reason
				done()
		it ' should return rejected promise from crudRead', (done) ->
			expect(r.crudRead.callCount).toEqual 0
			expect(promisedReason).toEqual 'get method doesn\'t support array of properties ... yet'
			done()
	describe ' propertyList is an invalid property', ->
		promisedReason = null
		beforeEach (done) ->
			spyOn(r, 'crudRead').andReturn null
			r.get('id param', 'badPropertyX').then null, (reason) ->
				promisedReason = reason
				done()
		it ' should return rejected promise from crudRead', (done) ->
			expect(r.crudRead.callCount).toEqual 0
			expect(promisedReason).toEqual 'INVALID PROPERTY - UNKNOWN : badPropertyX is not a propertyList of TestResource'
			done()
	describe ' propertyList uses a reference that specifies an invalid id property', ->
		promisedReason = null
		beforeEach (done) ->
			r.propertyMap['badPropertyA'] = {type: 'reference', resource: 'TestResource', idProperty: 'propertyM'}
			spyOn(r, 'crudRead').andReturn null
			r.get('id param', 'badPropertyA').then null, (reason) ->
				promisedReason = reason
				done()
		it ' should return rejected promise from crudRead', (done) ->
			expect(r.crudRead.callCount).toEqual 0
			expect(promisedReason).toEqual 'INVALID REFERENCE - UNKNOWN PROPERTY : propertyM referenced by badPropertyA definition but doesn\'t exist'
			done()
	describe ' propertyList uses a reference that specifies a property to another reference', ->
		promisedReason = null
		beforeEach (done) ->
			r.propertyMap['badPropertyB'] = {type: 'reference', resource: 'TestResource', idProperty: 'propertyF'}
			spyOn(r, 'crudRead').andReturn null
			r.get('id param', 'badPropertyB').then null, (reason) ->
				promisedReason = reason
				done()
		it ' should return rejected promise from crudRead', (done) ->
			expect(r.crudRead.callCount).toEqual 0
			expect(promisedReason).toEqual 'INVALID REFERENCE - TYPE : propertyF is not a value or value list as required by badPropertyB definition'
			done()
	describe ' propertyList uses a reference that specifies an invalid resource', ->
		promisedReason = null
		beforeEach (done) ->
			r.propertyMap['badPropertyC'] = {type: 'reference', resource: 'TestResourceTest', idProperty: 'propertyE'}
			spyOn(r, 'crudRead').andReturn null
			r.get('id param', 'badPropertyC').then null, (reason) ->
				promisedReason = reason
				done()
		it ' should return rejected promise from crudRead', (done) ->
			expect(r.crudRead.callCount).toEqual 0
			expect(promisedReason).toEqual 'INVALID REFERENCE - RESOURCE : TestResourceTest was not provided by the resource factory'
			done()
	describe ' propertyList uses a reference that specifies an invalid type', ->
		promisedReason = null
		beforeEach (done) ->
			r.propertyMap['badPropertyD'] = {type: 'invalidType', resource: 'TestResource', idProperty: 'propertyB'}
			spyOn(r, 'crudRead').andReturn null
			r.get('id param', 'badPropertyD').then null, (reason) ->
				promisedReason = reason
				done()
		it ' should return rejected promise from crudRead', (done) ->
			expect(r.crudRead.callCount).toEqual 0
			expect(promisedReason).toEqual 'INVALID PROPERTY - TYPE : invalidType is not a recognized propertyList type'
			done()
