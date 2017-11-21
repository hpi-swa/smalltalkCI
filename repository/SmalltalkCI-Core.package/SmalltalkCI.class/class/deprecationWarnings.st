helpers
deprecationWarnings
	^ DeprecationWarnings ifNil: [ DeprecationWarnings := OrderedCollection new ]