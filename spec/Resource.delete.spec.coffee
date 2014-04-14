TestResource = require './sample/TestResourceDelete'
testData = require './sample/TestData.json'

_ = require 'lodash'

describe 'Resource delete', ->
	r = null
	beforeEach ->
		r = new TestResource
		# TestResource is really TestResourceDelete, but not for testing
		r.getResourceFactory().addResource r, 'TestResource'
		r.setData _.cloneDeep testData
	describe ' a value', ->
		describe ' for a valid id', ->
			value = null
			beforeEach (done) ->
				r.delete(1).then (result) ->
					value = result
					done()
			it ' should promise true', (done) ->
				expect(value).toEqual 1
				done()
		describe ' for an invalid id', ->
			value = null
			beforeEach (done) ->
				r.delete(2).then (result) ->
					value = result
					done()
			it ' should promise false', (done) ->
				expect(value).toEqual null
				done()
	describe ' a list of values', ->
		describe ' for a valid ids', ->
			value = null
			beforeEach (done) ->
				r.delete([1, 5]).then (result) ->
					value = result
					done()
			it ' should promise a list of ids', (done) ->
				expect(value).toEqual [1, 5]
				done()
		describe ' for some valid ids', ->
			value = null
			beforeEach (done) ->
				r.delete([1, 2]).then (result) ->
					value = result
					done()
			it ' should promise a list of ids', (done) ->
				expect(value).toEqual [1]
				done()
		describe ' for no valid ids', ->
			value = null
			beforeEach (done) ->
				r.delete([2, 3]).then (result) ->
					value = result
					done()
			it ' should promise an empty list', (done) ->
				expect(value).toEqual []
				done()
