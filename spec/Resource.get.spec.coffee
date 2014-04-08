TestResource = require './sample/TestResourceRead'

describe 'Resource', ->
	r = null
	beforeEach ->
		r = new TestResource
		# TestResource is really TestResourceRead, but not for testing
		r.getResourceFactory().addResource r, 'TestResource'
	describe 'when using get', ->
		describe 'and a value id param', ->
			describe 'and no property specified', ->
				value = null
				beforeEach (done) ->
					r.get(1).then (result) ->
						value = result
						done()
				it 'should provide a promise to a complete object representing the resource', (done) ->
					expect(value).toEqual {
						propertyA: 1
						propertyB: 5
						propertyC: 'X'
						propertyD: [5, 6]
						propertyE: ['X']
					}
					done()
			describe 'and a value property', ->
				value = null
				beforeEach (done) ->
					r.get(1, 'propertyA').then (result) ->
						value = result
						done()
				it 'should provide a promise to a value', (done) ->
					expect(value).toEqual 1
					done()
			describe 'and a string value property', ->
				value = null
				beforeEach (done) ->
					r.get(1, 'propertyC').then (result) ->
						value = result
						done()
				it 'should provide a promise to a string value', (done) ->
					expect(value).toEqual 'X'
					done()
			describe 'and a value list property', ->
				value = null
				beforeEach (done) ->
					r.get(1, 'propertyD').then (result) ->
						value = result
						done()
				it 'should provide a promise to a value list', (done) ->
					expect(value).toEqual [5, 6]
					done()
			describe 'and a string value list property', ->
				value = null
				beforeEach (done) ->
					r.get(1, 'propertyE').then (result) ->
						value = result
						done()
				it 'should provide a promise to a string value list', (done) ->
					expect(value).toEqual ['X']
					done()
			describe 'and a reference with a value id property and reference is null', ->
				value = null
				beforeEach (done) ->
					r.get(5, 'propertyF').then (result) ->
						value = result
						done()
				it 'should provide a promise to null', (done) ->
					expect(value).toEqual null
					done()
			describe 'and a reference with a value id property', ->
				value = null
				beforeEach (done) ->
					r.get(1, 'propertyF').then (result) ->
						value = result
						done()
				it 'should provide a promise to an object', (done) ->
					expect(value).toEqual {
						propertyA: 5
						propertyB: null
						propertyC: ''
						propertyD: [1]
						propertyE: []
					}
					done()
			describe 'and a reference with a string value id property', ->
				value = null
				beforeEach (done) ->
					r.get(1, 'propertyG').then (result) ->
						value = result
						done()
				it 'should provide a promise to an object', (done) ->
					expect(value).toEqual {
						propertyA: 'X'
						propertyB: null
						propertyC: null
						propertyD: []
						propertyE: []
					}
					done()
			describe 'and a list of references, value list id property', ->
				value = null
				beforeEach (done) ->
					r.get(1, 'propertyH').then (result) ->
						value = result
						done()
				it 'should provide a promise to a list of objects', (done) ->
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
			describe 'and a list of references, string value list id property', ->
				value = null
				beforeEach (done) ->
					r.get(1, 'propertyI').then (result) ->
						value = result
						done()
				it 'should provide a promise to a list of objects', (done) ->
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
		describe 'and a value id is an object', ->
			describe 'and no property specified', ->
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
				it 'should provide a promise to a complete object representing the resource', (done) ->
					expect(value).toEqual obj
					done()
			describe 'and value property specified', ->
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
				it 'should provide a promise to a value', (done) ->
					expect(value).toEqual 1
					done()
			describe 'and a reference with a value id property', ->
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
				it 'should provide a promise to an object', (done) ->
					expect(value).toEqual {
						propertyA: 5
						propertyB: null
						propertyC: ''
						propertyD: [1]
						propertyE: []
					}
					done()
			describe 'and a list of references, value list id property', ->
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
				it 'should provide a promise to a list of objects', (done) ->
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
		describe 'and value id is a list', ->
			describe 'and no property specified', ->
				value = null
				beforeEach (done) ->
					r.get([5, 6]).then (result) ->
						value = result
						done()
				it 'should provide a promise to a list of complete objects representing the resource', (done) ->
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
			describe 'and no property specified', ->
				value = null
				beforeEach (done) ->
					r.get([5, 5]).then (result) ->
						value = result
						done()
				it 'should provide a promise to a list of complete objects representing the resource', (done) ->
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
			describe 'and a list of references, value list id property', ->
				value = null
				beforeEach (done) ->
					r.get([5, 6], 'propertyD').then (result) ->
						value = result
						done()
				it 'should provide a promise to a list of objects', (done) ->
					expect(value).toEqual [[1], []]
					done()
			describe 'and a list of reference, value id property and reference is null', ->
				value = null
				beforeEach (done) ->
					r.get([5, 6], 'propertyF').then (result) ->
						value = result
						done()
				it 'should provide a promise to an object', (done) ->
					expect(value).toEqual [null, {
						propertyA: 5
						propertyB: null
						propertyC: ''
						propertyD: [1]
						propertyE: []
					}]
					done()
		describe 'and value is a list of objects', ->
			describe 'and a list of references, value list id property', ->
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
				it 'should provide a promise to a list of objects', (done) ->
					expect(value).toEqual [[1], []]
					done()
