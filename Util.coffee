q = require 'q'

Util = {
	reject: (reason = null) ->
		defer = q.defer()
		defer.reject(reason)
		return defer.promise
}

module.exports = Util
