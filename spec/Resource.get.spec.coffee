TestResource = require './sample/TestResourceRead'
testData = require './sample/TestData.json'

describe 'Resource get', ->
	r = null
	beforeEach ->
		r = new TestResource
		# TestResource is really TestResourceRead, but not for testing
		r.getResourceFactory().addResource r, 'TestResource'
		r.setData testData
	describe ' a value id for a non existent id', ->
		value = null
		beforeEach (done) ->
			r.get(2).then (result) ->
				value = result
				done()
		it ' should promise null', (done) ->
			expect(value).toEqual null
			done()
	describe ' a list of value ids for a non existent ids', ->
		value = null
		beforeEach (done) ->
			r.get([2, 3]).then (result) ->
				value = result
				done()
		it ' should promise an empty list', (done) ->
			expect(value).toEqual []
			done()
	describe ' a list of value ids some are for non existent ids', ->
		value = null
		beforeEach (done) ->
			r.get([2, 5]).then (result) ->
				value = result
				done()
		it ' should promise a list with only the valid objects', (done) ->
			expect(value).toEqual [
				{
					propertyA: 5
					propertyB: null
					propertyC: ''
					propertyD: [1]
					propertyE: []
				}
			]
			done()
	describe ' a value id', ->
		describe ' no propertyList specified', ->
			value = null
			beforeEach (done) ->
				r.get(1).then (result) ->
					value = result
					done()
			it ' should promise an object', (done) ->
				expect(value).toEqual {
					propertyA: 1
					propertyB: 5
					propertyC: 'X'
					propertyD: [5, 6]
					propertyE: ['X']
				}
				done()
		describe ' a value property', ->
			value = null
			beforeEach (done) ->
				r.get(1, 'propertyA').then (result) ->
					value = result
					done()
			it ' should promise a value', (done) ->
				expect(value).toEqual 1
				done()
		describe ' a string value property', ->
			value = null
			beforeEach (done) ->
				r.get(1, 'propertyC').then (result) ->
					value = result
					done()
			it ' should promise a string value', (done) ->
				expect(value).toEqual 'X'
				done()
		describe ' a value list property', ->
			value = null
			beforeEach (done) ->
				r.get(1, 'propertyD').then (result) ->
					value = result
					done()
			it ' should promise a value list', (done) ->
				expect(value).toEqual [5, 6]
				done()
		describe ' a string value list property', ->
			value = null
			beforeEach (done) ->
				r.get(1, 'propertyE').then (result) ->
					value = result
					done()
			it ' should promise a string value list', (done) ->
				expect(value).toEqual ['X']
				done()
		describe ' a reference with a value id property and the reference is null', ->
			value = null
			beforeEach (done) ->
				r.get(5, 'propertyF').then (result) ->
					value = result
					done()
			it ' should promise null', (done) ->
				expect(value).toEqual null
				done()
		describe ' a reference with a value id property', ->
			value = null
			beforeEach (done) ->
				r.get(1, 'propertyF').then (result) ->
					value = result
					done()
			it ' should promise an object', (done) ->
				expect(value).toEqual {
					propertyA: 5
					propertyB: null
					propertyC: ''
					propertyD: [1]
					propertyE: []
				}
				done()
		describe ' a reference with a string value id property', ->
			value = null
			beforeEach (done) ->
				r.get(1, 'propertyG').then (result) ->
					value = result
					done()
			it ' should promise an object', (done) ->
				expect(value).toEqual {
					propertyA: 'X'
					propertyB: null
					propertyC: null
					propertyD: []
					propertyE: []
				}
				done()
		describe ' a list of references, value list id property', ->
			value = null
			beforeEach (done) ->
				r.get(1, 'propertyH').then (result) ->
					value = result
					done()
			it ' should promise a list of objects', (done) ->
				expect(value).toEqual [
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
		describe ' a list of references, string value list id property', ->
			value = null
			beforeEach (done) ->
				r.get(1, 'propertyI').then (result) ->
					value = result
					done()
			it ' should promise a list of objects', (done) ->
				expect(value).toEqual [
					{
						propertyA: 'X'
						propertyB: null
						propertyC: null
						propertyD: []
						propertyE: []
					}
				]
				done()
	describe ' a value id is an object', ->
		describe ' no property specified', ->
			value = null
			obj = {
				propertyA: 1
				propertyB: 5
				propertyC: 'X'
				propertyD: [5, 6]
				propertyE: ['X']
			}
			beforeEach (done) ->
				r.get(obj).then (result) ->
					value = result
					done()
			it ' should promise an object', (done) ->
				expect(value).toEqual obj
				done()
		describe ' value property specified', ->
			value = null
			obj = {
				propertyA: 1
				propertyB: 5
				propertyC: 'X'
				propertyD: [5, 6]
				propertyE: ['X']
			}
			beforeEach (done) ->
				r.get(obj, 'propertyA').then (result) ->
					value = result
					done()
			it ' should promise a value', (done) ->
				expect(value).toEqual 1
				done()
		describe ' a reference with a value id property', ->
			value = null
			obj = {
				propertyA: 1
				propertyB: 5
				propertyC: 'X'
				propertyD: [5, 6]
				propertyE: ['X']
			}
			beforeEach (done) ->
				r.get(obj, 'propertyF').then (result) ->
					value = result
					done()
			it ' should promise an object', (done) ->
				expect(value).toEqual {
					propertyA: 5
					propertyB: null
					propertyC: ''
					propertyD: [1]
					propertyE: []
				}
				done()
		describe ' a list of references, value list id property', ->
			value = null
			obj = {
				propertyA: 1
				propertyB: 5
				propertyC: 'X'
				propertyD: [5, 6]
				propertyE: ['X']
			}
			beforeEach (done) ->
				r.get(obj, 'propertyH').then (result) ->
					value = result
					done()
			it ' should promise a list of objects', (done) ->
				expect(value).toEqual [
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
	describe ' value id is a list', ->
		describe ' no property specified', ->
			value = null
			beforeEach (done) ->
				r.get([5, 6]).then (result) ->
					value = result
					done()
			it ' should promise a list of objects matching the resource', (done) ->
				expect(value).toEqual [
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
		describe ' no property specified', ->
			value = null
			beforeEach (done) ->
				r.get([5, 5]).then (result) ->
					value = result
					done()
			it ' should promise a list of objects matching the resource', (done) ->
				expect(value).toEqual [
					{
						propertyA: 5
						propertyB: null
						propertyC: ''
						propertyD: [1]
						propertyE: []
					},
					{
						propertyA: 5
						propertyB: null
						propertyC: ''
						propertyD: [1]
						propertyE: []
					}
				]
				done()
		describe ' a list of references, value list id property', ->
			value = null
			beforeEach (done) ->
				r.get([5, 6], 'propertyD').then (result) ->
					value = result
					done()
			it ' should promise a list of objects', (done) ->
				expect(value).toEqual [[1], []]
				done()
		describe ' a list of reference, value id property and reference is null', ->
			value = null
			beforeEach (done) ->
				r.get([5, 6], 'propertyF').then (result) ->
					value = result
					done()
			it ' should promise an object', (done) ->
				expect(value).toEqual [null, {
					propertyA: 5
					propertyB: null
					propertyC: ''
					propertyD: [1]
					propertyE: []
				}]
				done()
	describe ' value is a list of objects', ->
		describe ' a list of references, value list id property', ->
			value = null
			beforeEach (done) ->
				r.get([
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
				], 'propertyD').then (result) ->
					value = result
					done()
			it ' should promise a list of objects', (done) ->
				expect(value).toEqual [[1], []]
				done()
