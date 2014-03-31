class ResourceFactory
	resourceMap: {}
	addResource: (resource) ->
		@resourceMap[resource.constructor.name] = resource
		return @
	getResource: (resourceClass) ->
		if typeof @resourceMap[resourceClass] == 'undefined'
			return null
		return @resourceMap[resourceClass]

module.exports = ResourceFactory
