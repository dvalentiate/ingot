Resource = require '../Resource'
_ = require 'lodash'
q = require 'q'

# {type: 'value'}
# {type: 'valueList'}
# {type: 'reference', resource: 'Resource', idProperty: 'propertyB'}

describe 'Resource navigate', ->
	r = null
	spyGetResult = null
	spyGetRejectReason = null
	promisedResult = null
	rejectedReason = null
	spyGetPropertyDefinitionResult = null
	beforeEach ->
		spyGetResult = null
		spyGetRejectReason = null
		promisedResult = null
		rejectedReason = null
		r = new Resource
		r.getResourceFactory().addResource r
		r._get = r.get # so that spy can be removed
		spyOn(r, 'get').andCallFake (id, propertyList = null) ->
			defer = q.defer()
			if spyGetRejectReason == null
				defer.resolve spyGetResult
			else
				defer.reject spyGetRejectReason
			return defer.promise
		r._getPropertyDefinition = r.getPropertyDefinition # so that spy can be removed
		spyOn(r, 'getPropertyDefinition').andCallFake (property) ->
			return spyGetPropertyDefinitionResult
	describe ' an empty path with any resourceObj', ->
		describe ' get is nominal', ->
			beforeEach (done) ->
				spyGetResult = 'an object'
				r.navigate('', 'id param').then (result) ->
					promisedResult = result
					done()
			it ' should have passed get a resource identifier', ->
				expect(r.get.callCount).toEqual 1
				expect(r.get.mostRecentCall.args).toEqual ['id param']
			it ' should return a promise with the promised value being from get', ->
				expect(promisedResult).toEqual spyGetResult
		describe ' get rejects promise', ->
			beforeEach (done) ->
				spyGetRejectReason = 'not feeling like it'
				r.navigate('', 'id param').then null, (reason) ->
					rejectedReason = reason
					done()
			it ' should have passed get a resource identifier', ->
				expect(r.get.callCount).toEqual 1
				expect(r.get.mostRecentCall.args).toEqual ['id param']
			it ' should return a promise which is rejected', ->
				expect(rejectedReason).toEqual spyGetRejectReason
	describe ' path', ->
		describe ' a value with any resourceObj', ->
			beforeEach ->
				spyGetPropertyDefinitionResult = type: 'value'
			describe ' get is nominal', ->
				beforeEach (done) ->
					spyGetResult = 'a value'
					r.navigate('property param', 'id param').then (result) ->
						promisedResult = result
						done()
				it ' should have passed get a resource identifier', ->
					expect(r.get.callCount).toEqual 1
					expect(r.get.mostRecentCall.args).toEqual ['id param', 'property param']
				it ' should return a promise with the promised value being from get', ->
					expect(promisedResult).toEqual spyGetResult
			describe ' get rejects promise', ->
				beforeEach (done) ->
					spyGetRejectReason = 'not feeling like it'
					r.navigate('property param', 'id param').then null, (reason) ->
						rejectedReason = reason
						done()
				it ' should have passed get a resource identifier', ->
					expect(r.get.callCount).toEqual 1
					expect(r.get.mostRecentCall.args).toEqual ['id param', 'property param']
				it ' should return a promise which is rejected', ->
					expect(rejectedReason).toEqual spyGetRejectReason
		describe ' a value list', ->
			beforeEach ->
				spyGetPropertyDefinitionResult = type: 'valueList'
			describe ' a non singular resourceObj', ->
				describe ' get is nominal', ->
					beforeEach (done) ->
						spyGetResult = 'a value'
						r.navigate('property param', 'id param').then (result) ->
							promisedResult = result
							done()
					it ' should have passed get a resource identifier', ->
						expect(r.get.callCount).toEqual 1
						expect(r.get.mostRecentCall.args).toEqual ['id param', 'property param']
					it ' should return a promise with the promised value being from get', ->
						expect(promisedResult).toEqual spyGetResult
				describe ' get rejects promise', ->
					beforeEach (done) ->
						spyGetRejectReason = 'not feeling like it'
						r.navigate('property param', 'id param').then null, (reason) ->
							rejectedReason = reason
							done()
					it ' should have passed get a resource identifier', ->
						expect(r.get.callCount).toEqual 1
						expect(r.get.mostRecentCall.args).toEqual ['id param', 'property param']
					it ' should return a promise which is rejected', ->
						expect(rejectedReason).toEqual spyGetRejectReason
			describe ' a resourceObj list', ->
				describe ' get is nominal', ->
					beforeEach (done) ->
						spyGetResult = [['a value 1', 'a value 2'], ['a value 2']]
						r.navigate('property param', ['id param 1', 'id param 2']).then (result) ->
							promisedResult = result
							done()
					it ' should have passed get a resource identifier', ->
						expect(r.get.callCount).toEqual 1
						expect(r.get.mostRecentCall.args).toEqual [['id param 1', 'id param 2'], 'property param']
					it ' should return a promise with the promised value being from get', ->
						expect(promisedResult).toEqual ['a value 1', 'a value 2']
				describe ' get rejects promise', ->
					beforeEach (done) ->
						spyGetRejectReason = 'not feeling like it'
						r.navigate('property param', ['id param 1', 'id param 2']).then null, (reason) ->
							rejectedReason = reason
							done()
					it ' should have passed get a resource identifier', ->
						expect(r.get.callCount).toEqual 1
						expect(r.get.mostRecentCall.args).toEqual [['id param 1', 'id param 2'], 'property param']
					it ' should return a promise which is rejected', ->
						expect(rejectedReason).toEqual spyGetRejectReason
		describe ' a one to one reference', ->
			beforeEach ->
				r.get = r._get # removes existing spy
				spyOn(r, 'get').andCallFake (id, propertyList = null) ->
					defer = q.defer()
					if spyGetRejectReason != null && typeof spyGetRejectReason[id] != 'undefined'
						defer.reject spyGetRejectReason[id]
					else
						defer.resolve spyGetResult[id]
					return defer.promise
				r.getPropertyDefinition = r._getPropertyDefinition # removes existing spy
				spyOn(r, 'getPropertyDefinition').andCallFake (property) ->
					return spyGetPropertyDefinitionResult[property]
			describe ' get is nominal', ->
				beforeEach (done) ->
					spyGetPropertyDefinitionResult =
						'reference property param': {type: 'reference', resource: 'Resource', idProperty: 'referenced id param'}
					spyGetResult =
						'id param': 'referenced id param'
						'referenced id param': 'an object'
					r.navigate('reference property param', 'id param').then (result) ->
						promisedResult = result
						done()
				it ' should have passed get a resource identifier', ->
					expect(r.get.callCount).toEqual 2
					expect(r.get.calls[0].args).toEqual ['id param', 'reference property param']
					expect(r.get.calls[1].args).toEqual ['referenced id param']
				it ' should return a promise with the promised value being from get', ->
					expect(promisedResult).toEqual 'an object'
			describe ' reference get rejects promise', ->
				beforeEach (done) ->
					spyGetPropertyDefinitionResult =
						'reference property param': {type: 'reference', resource: 'Resource', idProperty: 'referenced id param'}
					spyGetRejectReason = 'id param': 'not feeling like it'
					r.navigate('reference property param', 'id param').then null, (reason) ->
						rejectedReason = reason
						done()
				it ' should have passed get a resource identifier', ->
					expect(r.get.callCount).toEqual 1
					expect(r.get.calls[0].args).toEqual ['id param', 'reference property param']
				it ' should return a promise which is rejected', ->
					expect(rejectedReason).toEqual 'not feeling like it'
			describe ' referenced resource get rejects promise', ->
				beforeEach (done) ->
					spyGetPropertyDefinitionResult =
						'reference property param': {type: 'reference', resource: 'Resource', idProperty: 'referenced id param'}
					spyGetResult =
						'id param': 'referenced id param'
					spyGetRejectReason = 'referenced id param': 'not feeling like it'
					r.navigate('reference property param', 'id param').then null, (reason) ->
						rejectedReason = reason
						done()
				it ' should have passed get a resource identifier', ->
					expect(r.get.callCount).toEqual 2
					expect(r.get.calls[0].args).toEqual ['id param', 'reference property param']
					expect(r.get.calls[1].args).toEqual ['referenced id param']
				it ' should return a promise which is rejected', ->
					expect(rejectedReason).toEqual 'not feeling like it'
		describe ' property of referenced resource is specified', ->
			beforeEach ->
				spyOn(r, 'get').andCallFake (id, propertyList = null) ->
					defer = q.defer()
					if id == 'id param'
						defer.resolve 
					else
						defer.reject spyGetRejectReason
					return defer.promise
				spyOn(r, 'getPropertyDefinition').andCallFake (property) ->
					if property == 'reference property param'
						return {type: 'reference', resource: 'Resource', idProperty: 'id param'}
					else
						return {type: 'value'}
			describe ' reference get call and property get call are nominal', ->
				promisedResult = null
				beforeEach (done) ->
					r.navigate('reference property/property', 'id param').then (result) ->
						promisedResult = result
						done()
					it ' should have passed get a resource identifier', ->
						expect(r.get.callCount).toEqual 1
						expect(r.get.mostRecentCall.args).toEqual [['id param 1', 'id param 2'], 'property param']
					it ' should return a promise with the promised value being from get', ->
						expect(promisedResult).toEqual ['a value 1', 'a value 2']
