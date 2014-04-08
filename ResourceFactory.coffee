class ResourceFactory
	resourceMap: {}
	addResource: (resource, name = null) ->
		if name == null
			name = resource.constructor.name
		@resourceMap[name] = resource
		return @
	getResource: (resourceClass) ->
		if typeof @resourceMap[resourceClass] == 'undefined'
			return null
		return @resourceMap[resourceClass]

module.exports = ResourceFactory
