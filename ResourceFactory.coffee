class ResourceFactory
	resourceMap: {}
	addResource: (resource) ->
		resource.setResourceFactory resource
		@resourceMap[resource.class] = resource
		@
	getResource: (resourceClass) ->
		@resourceMap[resourceClass]

exports.ResourceFactory = ResourceFactory
