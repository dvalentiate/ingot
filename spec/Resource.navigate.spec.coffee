Resource = require '../Resource'
_ = require 'lodash'
q = require 'q'

# {type: 'value'}
# {type: 'valueList'}
# {type: 'reference', resource: 'Resource', idProperty: 'propertyB'}

describe 'Resource navigate', ->
	r = null
	expectedResult = null
	expectedGetRejectReason = null
	promisedResult = null
	rejectedReason = null
	propertyDefinition = null
	beforeEach ->
		expectedResult = null
		expectedGetRejectReason = null
		promisedResult = null
		rejectedReason = null
		r = new Resource
		r.getResourceFactory().addResource r
		# r.propertyMap = propertyMap
		spyOn(r, 'get').andCallFake (id, propertyList = null) ->
			defer = q.defer()
			if expectedGetRejectReason == null
				defer.resolve expectedResult
			else
				defer.reject expectedGetRejectReason
			return defer.promise
		spyOn(r, 'getPropertyDefinition').andCallFake (property) ->
			return propertyDefinition
	describe ' an empty path with any resourceObj', ->
		describe ' get is nominal', ->
			beforeEach (done) ->
				expectedResult = 'an object'
				r.navigate('', 'id param').then (result) ->
					promisedResult = result
					done()
			it ' should have passed get a resource identifier', ->
				expect(r.get.callCount).toEqual 1
				expect(r.get.mostRecentCall.args).toEqual ['id param']
			it ' should return a promise with the promised value being from get', ->
				expect(promisedResult).toEqual expectedResult
		describe ' get rejects promise', ->
			beforeEach (done) ->
				expectedGetRejectReason = 'not feeling like it'
				r.navigate('', 'id param').then null, (reason) ->
					rejectedReason = reason
					done()
			it ' should have passed get a resource identifier', ->
				expect(r.get.callCount).toEqual 1
				expect(r.get.mostRecentCall.args).toEqual ['id param']
			it ' should return a promise which is rejected', ->
				expect(rejectedReason).toEqual expectedGetRejectReason
	describe ' path', ->
		describe ' a value with any resourceObj', ->
			beforeEach ->
				propertyDefinition = {type: 'value'}
			describe ' get is nominal', ->
				beforeEach (done) ->
					expectedResult = 'a value'
					r.navigate('property param', 'id param').then (result) ->
						promisedResult = result
						done()
				it ' should have passed get a resource identifier', ->
					expect(r.get.callCount).toEqual 1
					expect(r.get.mostRecentCall.args).toEqual ['id param', 'property param']
				it ' should return a promise with the promised value being from get', ->
					expect(promisedResult).toEqual expectedResult
			describe ' get rejects promise', ->
				beforeEach (done) ->
					expectedGetRejectReason = 'not feeling like it'
					r.navigate('property param', 'id param').then null, (reason) ->
						rejectedReason = reason
						done()
				it ' should have passed get a resource identifier', ->
					expect(r.get.callCount).toEqual 1
					expect(r.get.mostRecentCall.args).toEqual ['id param', 'property param']
				it ' should return a promise which is rejected', ->
					expect(rejectedReason).toEqual expectedGetRejectReason
		describe ' a value list', ->
			beforeEach ->
				propertyDefinition = {type: 'valueList'}
			describe ' a non singular resourceObj', ->
				describe ' get is nominal', ->
					beforeEach (done) ->
						expectedResult = 'a value'
						r.navigate('property param', 'id param').then (result) ->
							promisedResult = result
							done()
					it ' should have passed get a resource identifier', ->
						expect(r.get.callCount).toEqual 1
						expect(r.get.mostRecentCall.args).toEqual ['id param', 'property param']
					it ' should return a promise with the promised value being from get', ->
						expect(promisedResult).toEqual expectedResult
				describe ' get rejects promise', ->
					beforeEach (done) ->
						expectedGetRejectReason = 'not feeling like it'
						r.navigate('property param', 'id param').then null, (reason) ->
							rejectedReason = reason
							done()
					it ' should have passed get a resource identifier', ->
						expect(r.get.callCount).toEqual 1
						expect(r.get.mostRecentCall.args).toEqual ['id param', 'property param']
					it ' should return a promise which is rejected', ->
						expect(rejectedReason).toEqual expectedGetRejectReason
			describe ' a resourceObj list', ->
				describe ' get is nominal', ->
					beforeEach (done) ->
						expectedResult = ['a value 2']
						r.navigate('property param', ['id param 1', 'id param 2']).then (result) ->
							promisedResult = result
							done()
					it ' should have passed get a resource identifier', ->
						expect(r.get.callCount).toEqual 1
						expect(r.get.mostRecentCall.args).toEqual [['id param 1', 'id param 2'], 'property param']
					it ' should return a promise with the promised value being from get', ->
						expect(promisedResult).toEqual expectedResult
				describe ' get rejects promise', ->
					beforeEach (done) ->
						expectedGetRejectReason = 'not feeling like it'
						r.navigate('property param', ['id param 1', 'id param 2']).then null, (reason) ->
							rejectedReason = reason
							done()
					it ' should have passed get a resource identifier', ->
						expect(r.get.callCount).toEqual 1
						expect(r.get.mostRecentCall.args).toEqual [['id param 1', 'id param 2'], 'property param']
					it ' should return a promise which is rejected', ->
						expect(rejectedReason).toEqual expectedGetRejectReason
###
		describe ' a reference', ->
			describe ' a value id', ->
				describe ' object resourceObj', ->
					promisedResult = null
					beforeEach (done) ->
						r.navigate('propertyD', testData['1']).then (result) ->
							promisedResult = result
							done()
					it ' should promise an object equalling the reference\'s id', (done) ->
						expect(promisedResult).toEqual testData['5']
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [testData['1'], 'propertyD']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [testData['5']]
				describe ' object with null reference resourceObj', ->
					promisedResult = null
					beforeEach (done) ->
						r.navigate('propertyD', testData['5']).then (result) ->
							promisedResult = result
							done()
					it ' should promise an empty list of objects', (done) ->
						expect(promisedResult).toEqual null
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [testData['5'], 'propertyD']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [null]
				describe ' list with one object with null reference resourceObj', ->
					promisedResult = null
					beforeEach (done) ->
						r.navigate('propertyD', [testData['5']]).then (result) ->
							promisedResult = result
							done()
					it ' should promise an empty list of objects', (done) ->
						expect(promisedResult).toEqual []
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [[testData['5']], 'propertyD']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [[]]
				describe ' list of objects resourceObj', ->
					promisedResult = null
					beforeEach (done) ->
						r.navigate('propertyD', [testData['5'], testData['6']]).then (result) ->
							promisedResult = result
							done()
					it ' should promise a list of objects matching the reference\'s id', (done) ->
						expect(promisedResult).toEqual [testData['5']]
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [[testData['5'], testData['6']], 'propertyD']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [[testData['5']]]
			describe ' value list id reference', ->
				describe ' object resourceObj', ->
					promisedResult = null
					beforeEach (done) ->
						r.navigate('propertyE', testData['1']).then (result) ->
							promisedResult = result
							done()
					it ' should promise a list of objects matching the reference\'s id', (done) ->
						expect(promisedResult).toEqual [testData['5'], testData['6']]
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [testData['1'], 'propertyE']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [[testData['5'], testData['6']]]
				describe ' list of objects resourceObj', ->
					promisedResult = null
					beforeEach (done) ->
						r.navigate('propertyE', [testData['5'], testData['6']]).then (result) ->
							promisedResult = result
							done()
					it ' should promise a list of objects matching the reference\'s id', (done) ->
						expect(promisedResult).toEqual [testData['1']]
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [[testData['5'], testData['6']], 'propertyE']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [[testData['1']]]
		describe ' multistep', ->
			describe ' to property', ->
				promisedResult = null
				beforeEach (done) ->
					r.navigate('propertyE/propertyA', 1).then (result) ->
						promisedResult = result
						done()
				it ' should promise a list of values', (done) ->
					expect(promisedResult).toEqual [5, 6]
					done()
			describe ' to reference', ->
				describe ' to value', ->
					promisedResult = null
					beforeEach (done) ->
						r.navigate('propertyE/propertyB', 1).then (result) ->
							promisedResult = result
							done()
					it ' should promise a list of values', (done) ->
						expect(promisedResult).toEqual [null, 5]
						done()
				describe ' to list of values', ->
					promisedResult = null
					beforeEach (done) ->
						r.navigate('propertyE/propertyC', 1).then (result) ->
							promisedResult = result
							done()
					it ' should promise a list of values', (done) ->
						expect(promisedResult).toEqual [1]
						done()
				describe ' to 2nd reference', ->
					promisedResult = null
					beforeEach (done) ->
						r.navigate('propertyE/propertyD', 1).then (result) ->
							promisedResult = result
							done()
					it ' should promise a list of values', (done) ->
						expect(promisedResult).toEqual [testData['5']]
						done()
				describe ' to 2nd list of references', ->
					promisedResult = null
					beforeEach (done) ->
						r.navigate('propertyE/propertyE', 5).then (result) ->
							promisedResult = result
							done()
					it ' should promise a list of values', (done) ->
						expect(promisedResult).toEqual [testData['5'], testData['6']]
						done()
###