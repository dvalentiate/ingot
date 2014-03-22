class ResourceFactory
	resourceMap: {}
	addResource: (resource) ->
		@resourceMap[resource.constructor.name] = resource
		@
	getResource: (resourceClass) ->
		if typeof @resourceMap[resourceClass] == 'undefined'
			return null
		@resourceMap[resourceClass]

module.exports = ResourceFactory
