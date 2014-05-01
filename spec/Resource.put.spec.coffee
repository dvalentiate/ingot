TestResource = require './sample/TestCrudResourceUpdate'
testData = require './sample/TestData.json'
_ = require 'lodash'

describe 'Resource update', ->
	r = null
	beforeEach ->
		r = new TestResource
		# TestResource is really TestResourceUpdate, but not for testing
		r.getResourceFactory().addResource r, 'TestResource'
		r.setData _.cloneDeep testData
	describe ' a value', ->
		describe ' for a valid id', ->
			value = null
			beforeEach (done) ->
				r.put(1, {
					propertyB: 6
				}).then (result) ->
					value = result
					done()
			it ' should promise the updated id', (done) ->
				expect(value).toEqual {
					propertyA: 1
					propertyB: 6
					propertyC: 'X'
					propertyD: [5, 6]
					propertyE: ['X']
				}
				done()
			it ' should mean that the resource is updated', (done) ->
				r.get(1).then (result) ->
					expect(result).toEqual {
						propertyA: 1
						propertyB: 6
						propertyC: 'X'
						propertyD: [5, 6]
						propertyE: ['X']
					}
					done()
			it ' should mean that the other resources are not affected', (done) ->
				r.get([5, 6]).then (result) ->
					expect(result).toEqual [
						{
							propertyA: 5
							propertyB: null
							propertyC: ''
							propertyD: [1]
							propertyE: []
						},
						{
							propertyA: 6
							propertyB: 5
							propertyC: null
							propertyD: []
							propertyE: []
						}
					]
					done()
		describe ' for an invalid id', ->
			value = null
			beforeEach (done) ->
				r.put(2, {
					propertyB: 6
				}).then (result) ->
					value = result
					done()
			it ' should promise null', (done) ->
				expect(value).toEqual null
				done()
	describe ' a list of values', ->
		describe ' for a valid ids', ->
			value = null
			beforeEach (done) ->
				r.udpate([1, 5], {
					propertyB: 6
				}).then (result) ->
					value = result
					done()
			xit ' should promise a list of ids', (done) ->
				expect(value).toEqual [1, 5]
				done()
		describe ' for some valid ids', ->
			value = null
			beforeEach (done) ->
				r.put([1, 2], {
					propertyB: 6
				}).then (result) ->
					value = result
					done()
			xit ' should promise a list of ids', (done) ->
				expect(value).toEqual [1]
				done()
		describe ' for no valid ids', ->
			value = null
			beforeEach (done) ->
				r.put([2, 3], {
					propertyB: 6
				}).then (result) ->
					value = result
					done()
			xit ' should promise an empty list', (done) ->
				expect(value).toEqual []
				done()
