TestResource = require './sample/TestResource'
q = require 'q'
_ = require 'lodash'

fakeData = {
	'1': {
		'propertyA': 1,
		'propertyB': 5,
		'propertyC': [5, 6],
	},
	'5': {
		'propertyA': 5,
		'propertyB': null,
		'propertyC': [1],
	},
	'6': {
		'propertyA': 6,
		'propertyB': 5,
		'propertyC': [],
	}
}
fakeGet = (id, propertyList = null) ->
		defer = q.defer()
		multiple = _.isArray id
		if !multiple
			id = [id]
		
		result = []
		for x in id
			if x == null
				result.push null
				continue
			
			if _.isObject x
				content = x
			else
				content = fakeData[x + '']
			
			if typeof content == 'undefined'
				continue
			
			if propertyList != null
				definition = @getPropertyDefinition propertyList
				if definition.type == 'reference'
					referenceIdDefinition = @getPropertyDefinition definition.idProperty
					referencedResource = @getResourceFactory().getResource definition.resource
					if referenceIdDefinition.type == 'value'
						content = content[definition.idProperty]
						if content != null
							content = fakeData[content + '']
						result.push content
					if referenceIdDefinition.type == 'valueList'
						multiple = true
						content = content[definition.idProperty]
						for x in content
							if x != null
								result.push fakeData[x + '']
				if definition.type == 'value'
					result.push content[propertyList]
				if definition.type == 'valueList'
					result.push content[propertyList]
			else
				result.push content
			
		defer.resolve if multiple then result else result[0]
		return defer.promise

describe 'Resource.navigate', ->
	r = null
	beforeEach ->
		r = new TestResource
		# TestResource is really TestResourceRead, but not for testing
		r.getResourceFactory().addResource r, 'TestResource'
		spyOn(r, 'get').andCallFake fakeGet
	describe ' an empty path', ->
		describe ' a value resourceObj', ->
			value = null
			beforeEach (done) ->
				r.navigate('', 1).then (result) ->
					value = result
					done()
			it ' should promise an object with an id equalling resourceObj', (done) ->
				expect(value).toEqual fakeData['1']
				done()
			it ' should have used get once', ->
				expect(r.get.callCount).toEqual 1
			it ' should have passed get a resource identifier', ->
				expect(r.get.mostRecentCall.args).toEqual [1]
		describe ' an object resourceObj', ->
			value = null
			beforeEach (done) ->
				r.navigate('', fakeData['1']).then (result) ->
					value = result
					done()
			it ' should promise an object equalling resourceObj', (done) ->
				expect(value).toEqual fakeData['1']
				done()
			it ' should have used get once', ->
				expect(r.get.callCount).toEqual 1
			it ' should have passed get a resource object', ->
				expect(r.get.mostRecentCall.args).toEqual [fakeData['1']]
		describe ' a list of values resourceObj', ->
			value = null
			beforeEach (done) ->
				r.navigate('', [5, 6]).then (result) ->
					value = result
					done()
			it ' should promise a list of objects with ids equalling those in resourceObj', (done) ->
				expect(value).toEqual [fakeData['5'], fakeData['6']]
				done()
			it ' should have used get once', ->
				expect(r.get.callCount).toEqual 1
			it ' should have passed get a list of resource identifiers', ->
				expect(r.get.mostRecentCall.args).toEqual [[5, 6]]
		describe ' resourceObj param is a list of objects', ->
			value = null
			beforeEach (done) ->
				r.navigate('', [fakeData['5'], fakeData['6']]).then (result) ->
					value = result
					done()
			it ' should promise a list the resource objects that were passed in', (done) ->
				expect(value).toEqual [fakeData['5'], fakeData['6']]
				done()
			it ' should have used get once', ->
				expect(r.get.callCount).toEqual 1
			it ' should have passed get a list of resource objects', ->
				expect(r.get.mostRecentCall.args).toEqual [[fakeData['5'], fakeData['6']]]
	describe ' path', ->
		describe ' a value', ->
			describe ' a value resourceObj', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyB', 1).then (result) ->
						value = result
						done()
				it ' should promise a value equalliing the property in resourceObj', (done) ->
					expect(value).toEqual 5
					done()
				it ' should have used get once', ->
					expect(r.get.callCount).toEqual 1
				it ' should have passed get a resource identifier', ->
					expect(r.get.mostRecentCall.args).toEqual [1, 'propertyB']
			describe ' an object resourceObj', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyB', fakeData['1']).then (result) ->
						value = result
						done()
				it ' should promise a value equalling the property of resourceObject', (done) ->
					expect(value).toEqual 5
					done()
				it ' should have used get once', ->
					expect(r.get.callCount).toEqual 1
				it ' should have passed get a resource object', ->
					expect(r.get.mostRecentCall.args).toEqual [fakeData['1'], 'propertyB']
			describe ' a list of values resourceObj', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyA', [5, 6]).then (result) ->
						value = result
						done()
				it ' should promise a list of values equalling the property of each in resourceObj', (done) ->
					expect(value).toEqual [5, 6]
					done()
				it ' should have used get once', ->
					expect(r.get.callCount).toEqual 1
				it ' should have passed get a list of resource identifiers', ->
					expect(r.get.mostRecentCall.args).toEqual [[5, 6], 'propertyA']
			describe ' resourceObj param is a list of objects', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyA', [fakeData['5'], fakeData['6']]).then (result) ->
						value = result
						done()
				it ' should promise a list of values equalling the property of each in resourceObjects', (done) ->
					expect(value).toEqual [5, 6]
					done()
				it ' should have used get once', ->
					expect(r.get.callCount).toEqual 1
				it ' should have passed get a list of resource objects', ->
					expect(r.get.mostRecentCall.args).toEqual [[fakeData['5'], fakeData['6']], 'propertyA']
		describe ' a value list', ->
			describe ' a value resourceObj', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyC', 1).then (result) ->
						value = result
						done()
				it ' should promise the list values equalling the property in resourceObj', (done) ->
					expect(value).toEqual [5, 6]
					done()
				it ' should have used get once', ->
					expect(r.get.callCount).toEqual 1
				it ' should have passed get a resource identifier', ->
					expect(r.get.mostRecentCall.args).toEqual [1, 'propertyC']
			describe ' an object resourceObj', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyC', fakeData['1']).then (result) ->
						value = result
						done()
				it ' should promise the list values equalling the property in resourceObject', (done) ->
					expect(value).toEqual [5, 6]
					done()
				it ' should have used get once', ->
					expect(r.get.callCount).toEqual 1
				it ' should have passed get a resource object', ->
					expect(r.get.mostRecentCall.args).toEqual [fakeData['1'], 'propertyC']
			describe ' a list of values resourceObj', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyC', [5, 6]).then (result) ->
						value = result
						done()
				it ' should promise a consolodated list of values equalling the property in resourceObj', (done) ->
					expect(value).toEqual [1]
					done()
				it ' should have used get once', ->
					expect(r.get.callCount).toEqual 1
				it ' should have passed get a list of resource identifiers', ->
					expect(r.get.mostRecentCall.args).toEqual [[5, 6], 'propertyC']
			describe ' resourceObj param is a list of objects', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyC', [fakeData['5'], fakeData['6']]).then (result) ->
						value = result
						done()
				it ' should promise a consolodated list of values equalling the property for each in resourceObj', (done) ->
					expect(value).toEqual [1]
					done()
				it ' should have used get once', ->
					expect(r.get.callCount).toEqual 1
				it ' should have passed get a list of resource objects', ->
					expect(r.get.mostRecentCall.args).toEqual [[fakeData['5'], fakeData['6']], 'propertyC']
		describe ' a reference', ->
			describe ' a value id', ->
				describe ' object resourceObj', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyD', fakeData['1']).then (result) ->
							value = result
							done()
					it ' should promise an object equalling the reference\'s id', (done) ->
						expect(value).toEqual fakeData['5']
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [fakeData['1'], 'propertyD']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [fakeData['5']]
				describe ' object with null reference resourceObj', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyD', fakeData['5']).then (result) ->
							value = result
							done()
					it ' should promise an empty list of objects', (done) ->
						expect(value).toEqual null
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [fakeData['5'], 'propertyD']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [null]
				describe ' list with one object with null reference resourceObj', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyD', [fakeData['5']]).then (result) ->
							value = result
							done()
					it ' should promise an empty list of objects', (done) ->
						expect(value).toEqual []
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [[fakeData['5']], 'propertyD']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [[]]
				describe ' list of objects resourceObj', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyD', [fakeData['5'], fakeData['6']]).then (result) ->
							value = result
							done()
					it ' should promise a list of objects matching the reference\'s id', (done) ->
						expect(value).toEqual [fakeData['5']]
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [[fakeData['5'], fakeData['6']], 'propertyD']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [[fakeData['5']]]
			describe ' value list id reference', ->
				describe ' object resourceObj', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyE', fakeData['1']).then (result) ->
							value = result
							done()
					it ' should promise a list of objects matching the reference\'s id', (done) ->
						expect(value).toEqual [fakeData['5'], fakeData['6']]
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [fakeData['1'], 'propertyE']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [[fakeData['5'], fakeData['6']]]
				describe ' list of objects resourceObj', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyE', [fakeData['5'], fakeData['6']]).then (result) ->
							value = result
							done()
					it ' should promise a list of objects matching the reference\'s id', (done) ->
						expect(value).toEqual [fakeData['1']]
						done()
					it ' should have used get 2 times', ->
						expect(r.get.callCount).toEqual 2
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[0]).toEqual [[fakeData['5'], fakeData['6']], 'propertyE']
					it ' should have passed get a resource object', ->
						expect(r.get.argsForCall[1]).toEqual [[fakeData['1']]]
		describe ' multistep', ->
			describe ' to property', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyE/propertyA', 1).then (result) ->
						value = result
						done()
				it ' should promise a list of values', (done) ->
					expect(value).toEqual [5, 6]
					done()
			describe ' to reference', ->
				describe ' to value', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyE/propertyB', 1).then (result) ->
							value = result
							done()
					it ' should promise a list of values', (done) ->
						expect(value).toEqual [null, 5]
						done()
				describe ' to list of values', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyE/propertyC', 1).then (result) ->
							value = result
							done()
					it ' should promise a list of values', (done) ->
						expect(value).toEqual [1]
						done()
				describe ' to 2nd reference', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyE/propertyD', 1).then (result) ->
							value = result
							done()
					it ' should promise a list of values', (done) ->
						expect(value).toEqual [fakeData['5']]
						done()
				describe ' to 2nd list of references', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyE/propertyE', 5).then (result) ->
							value = result
							done()
					it ' should promise a list of values', (done) ->
						expect(value).toEqual [fakeData['5'], fakeData['6']]
						done()
