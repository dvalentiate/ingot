q = require 'q'

util = {
	reject: (reason = null) ->
		defer = q.defer()
		defer.reject(reason)
		return defer.promise
	resolve: (result = null) ->
		defer = q.defer()
		defer.reject(reason)
		return defer.promise
}

module.exports = util
