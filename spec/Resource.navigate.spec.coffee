TestResource = require './sample/TestResourceRead'

describe 'Resource', ->
	r = null
	beforeEach ->
		r = new TestResource
	describe 'when navigate is called with empty path param', ->
		describe 'and resource object param is a value', ->
			value = null
			beforeEach (done) ->
				r.navigate('', 1).then (result) ->
					value = result
					done()
			it 'should provide a promise to a resource object with a id equalling the param value', (done) ->
				expect(value).toEqual {
					propertyA: 1
					propertyB: 5
					propertyC: 'X'
					propertyD: [5, 6]
					propertyE: ['X']
				}
				done()
		describe 'and resource object param is an object', ->
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
			it 'should provide a promise to a resource object that was passed in', (done) ->
				expect(value).toEqual {
					propertyA: 1
					propertyB: 5
					propertyC: 'X'
					propertyD: [5, 6]
					propertyE: ['X']
				}
				done()
		describe 'and resource object param is a list of values', ->
			value = null
			beforeEach (done) ->
				r.navigate('', [5, 6]).then (result) ->
					value = result
					done()
			it 'should provide a promise to a list of resource objects with ids equalling those in the resource object param', (done) ->
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
		describe 'and resource object param is a list of objects', ->
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
			it 'should provide a promise to a list the resource objects that were passed in', (done) ->
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
	describe 'when navigate is called with non empty path param', ->
		describe 'and end node names a value property', ->
			describe 'and resource object param is a value', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyB', 1).then (result) ->
						value = result
						done()
				it 'should provide a promise to a value corresponding to the property of a resource object specified by the resource object param', (done) ->
					expect(value).toEqual 5
					done()
			describe 'and resource object param is an object', ->
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
				it 'should provide a promise to a value corresponding to the property of the passed resource object', (done) ->
					expect(value).toEqual 5
					done()
			describe 'and resource object param is a list of values', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyA', [5, 6]).then (result) ->
						value = result
						done()
				it 'should provide a promise to a list of values corresponding to the path property of each of the resource objects specified by the object resource list', (done) ->
					expect(value).toEqual [5, 6]
					done()
			describe 'and resource object param is a list of objects', ->
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
				it 'should provide a promise to a list of values corresponding to the path property of each of passed resource objects', (done) ->
					expect(value).toEqual [5, 6]
					done()
		describe 'and end node names a value list property', ->
			describe 'and resource object param is a value', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyD', 1).then (result) ->
						value = result
						done()
				it 'should provide a promise to the list values corresponding to the property of a resource object specified by the resource object param', (done) ->
					expect(value).toEqual [5, 6]
					done()
			describe 'and resource object param is an object', ->
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
				it 'should provide a promise to the list values corresponding to the property of the passed resource object', (done) ->
					expect(value).toEqual [5, 6]
					done()
			describe 'and resource object param is a list of values', ->
				value = null
				beforeEach (done) ->
					r.navigate('propertyD', [5, 6]).then (result) ->
						value = result
						done()
				it 'should provide a promise to a consolodated list of values corresponding to the path property for each of the resource objects specified by the object resource list', (done) ->
					expect(value).toEqual [1]
					done()
			describe 'and resource object param is a list of objects', ->
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
				it 'should provide a promise to a consolodated list of values corresponding to the path property for each of the provided resource objects', (done) ->
					expect(value).toEqual [1]
					done()
		describe 'and end node names a reference property', ->
			beforeEach ->
				# TestResource is really TestResourceRead, but not for testing
				r.getResourceFactory().addResource r, 'TestResource'
			describe 'and the reference is based on a value id property', ->
				describe 'and resource object is a resource object', ->
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
					it 'should provide a promise to a resource object corresponding to the reference\'s id property', (done) ->
						expect(value).toEqual {
							propertyA: 5
							propertyB: null
							propertyC: ''
							propertyD: [1]
							propertyE: []
						}
						done()
				describe 'and resource object is a list of a single resource object and reference points to null', ->
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
					it 'should provide a promise to a list of resource objects corresponding to the reference\'s id property', (done) ->
						expect(value).toEqual []
						done()
				describe 'and resource object is a list of resource objects', ->
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
					it 'should provide a promise to a list of resource objects corresponding to the reference\'s id property', (done) ->
						expect(value).toEqual [{
							propertyA: 5
							propertyB: null
							propertyC: ''
							propertyD: [1]
							propertyE: []
						}]
						done()
			describe 'and the reference is based on a value list id property', ->
				describe 'and resource object is a resource object', ->
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
					it 'should provide a promise to a list of resource objects corresponding to the reference\'s id property', (done) ->
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
				describe 'and resource object is a list of resource objects', ->
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
					it 'should provide a promise to a list of resource objects corresponding to the reference\'s id property', (done) ->
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
