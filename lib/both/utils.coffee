@adminCollectionObject = (collection) ->
	if typeof AdminConfig.collections[collection] != 'undefined' and typeof AdminConfig.collections[collection].collectionObject != 'undefined'
		AdminConfig.collections[collection].collectionObject
	else
		if Meteor.isServer
			global[collection]
		else
			window[collection]

@adminCallback = (name, args, callback) ->
	stop = false
	if typeof AdminConfig?.callbacks?[name] == 'function'
		stop = AdminConfig.callbacks[name](args...) is false
	if typeof callback == 'function'
		callback args... unless stop

@adminCollectionRoute = (collectionName) ->
	'admin_collections_' + collectionName + '_home0'

@lookup = (obj, ref) ->
	if typeof ref == 'undefined'
		ref = if Meteor.isServer then global else window
	if typeof obj == 'string'
		arr = obj.split '.'
		continue while arr.length and (ref = ref[arr.shift()])
		if not ref
			throw new Error(obj + ' is not in the ' + ref.toString())
		else
			return ref
	return obj