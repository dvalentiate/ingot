TestResource = require './sample/TestResourceRead'

describe 'Resource.navigate', ->
	r = null
	beforeEach ->
		r = new TestResource
		# TestResource is really TestResourceRead, but not for testing
		r.getResourceFactory().addResource r, 'TestResource'
	describe ' an empty path', ->
		describe ' a value resourceObj', ->
			value = null
			beforeEach (done) ->
				r.navigate('', 1).then (result) ->
					value = result
					done()
			it ' should promise an object with an id equalling resourceObj', (done) ->
				expect(value).toEqual {
					propertyA: 1
					propertyB: 5
					propertyC: 'X'
					propertyD: [5, 6]
					propertyE: ['X']
				}
				done()
		describe ' an object resourceObj', ->
			value = null
			beforeEach (done) ->
				r.navigate('', {
					propertyA: 1
					propertyB: 5
					propertyC: 'X'
					propertyD: [5, 6]
					propertyE: ['X']
				}).then (result) ->
					value = result
					done()
			it ' should promise an object equalling resourceObj', (done) ->
				expect(value).toEqual {
					propertyA: 1
					propertyB: 5
					propertyC: 'X'
					propertyD: [5, 6]
					propertyE: ['X']
				}
				done()
		describe ' a list of values resourceObj', ->
			value = null
			beforeEach (done) ->
				r.navigate('', [5, 6]).then (result) ->
					value = result
					done()
			it ' should promise a list of objects with ids equalling those in resourceObj', (done) ->
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
		describe ' resourceObj param is a list of objects', ->
			value = null
			beforeEach (done) ->
				r.navigate('', [
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
				]).then (result) ->
					value = result
					done()
			it ' should promise a list the resource objects that were passed in', (done) ->
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
			describe ' an object resourceObj', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyB', {
						propertyA: 1
						propertyB: 5
						propertyC: 'X'
						propertyD: [5, 6]
						propertyE: ['X']
					}).then (result) ->
						value = result
						done()
				it ' should promise a value equalling the property of resourceObject', (done) ->
					expect(value).toEqual 5
					done()
			describe ' a list of values resourceObj', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyA', [5, 6]).then (result) ->
						value = result
						done()
				it ' should promise a list of values equalling the property of each in resourceObj', (done) ->
					expect(value).toEqual [5, 6]
					done()
			describe ' resourceObj param is a list of objects', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyA', [
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
					]).then (result) ->
						value = result
						done()
				it ' should promise a list of values equalling the property of each in resourceObjects', (done) ->
					expect(value).toEqual [5, 6]
					done()
		describe ' a value list', ->
			describe ' a value resourceObj', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyD', 1).then (result) ->
						value = result
						done()
				it ' should promise the list values equalling the property in resourceObj', (done) ->
					expect(value).toEqual [5, 6]
					done()
			describe ' an object resourceObj', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyD', {
						propertyA: 1
						propertyB: 5
						propertyC: 'X'
						propertyD: [5, 6]
						propertyE: ['X']
					}).then (result) ->
						value = result
						done()
				it ' should promise the list values equalling the property in resourceObject', (done) ->
					expect(value).toEqual [5, 6]
					done()
			describe ' a list of values resourceObj', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyD', [5, 6]).then (result) ->
						value = result
						done()
				it ' should promise a consolodated list of values equalling the property in resourceObj', (done) ->
					expect(value).toEqual [1]
					done()
			describe ' resourceObj param is a list of objects', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyD', [
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
					]).then (result) ->
						value = result
						done()
				it ' should promise a consolodated list of values equalling the property for each in resourceObj', (done) ->
					expect(value).toEqual [1]
					done()
		describe ' a reference', ->
			describe ' a value id', ->
				describe ' object resourceObj', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyF', {
							propertyA: 1
							propertyB: 5
							propertyC: 'X'
							propertyD: [5, 6]
							propertyE: ['X']
						}).then (result) ->
							value = result
							done()
					it ' should promise an object equalling the reference\'s id', (done) ->
						expect(value).toEqual {
							propertyA: 5
							propertyB: null
							propertyC: ''
							propertyD: [1]
							propertyE: []
						}
						done()
				describe ' object with null reference resourceObj', ->
					value = null
					obj = [
						{
							propertyA: 5
							propertyB: null
							propertyC: ''
							propertyD: [1]
							propertyE: []
						}
					]
					beforeEach (done) ->
						r.navigate('propertyF', obj).then (result) ->
							value = result
							done()
					it ' should promise an empty list of objects', (done) ->
						expect(value).toEqual []
						done()
				describe ' list of objects resourceObj', ->
					value = null
					obj = [
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
					beforeEach (done) ->
						r.navigate('propertyF', obj).then (result) ->
							value = result
							done()
					it ' should promise a list of objects matching the reference\'s id', (done) ->
						expect(value).toEqual [{
							propertyA: 5
							propertyB: null
							propertyC: ''
							propertyD: [1]
							propertyE: []
						}]
						done()
			describe ' value list id reference', ->
				describe ' object resourceObj', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyH', {
							propertyA: 1
							propertyB: 5
							propertyC: 'X'
							propertyD: [5, 6]
							propertyE: ['X']
						}).then (result) ->
							value = result
							done()
					it ' should promise a list of objects matching the reference\'s id', (done) ->
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
				describe ' list of objects resourceObj', ->
					value = null
					beforeEach (done) ->
						r.navigate('propertyH', [
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
						]).then (result) ->
							value = result
							done()
					it ' should promise a list of objects matching the reference\'s id', (done) ->
						expect(value).toEqual [
							{
								propertyA: 1
								propertyB: 5
								propertyC: 'X'
								propertyD: [5, 6]
								propertyE: ['X']
							}
						]
						done()
