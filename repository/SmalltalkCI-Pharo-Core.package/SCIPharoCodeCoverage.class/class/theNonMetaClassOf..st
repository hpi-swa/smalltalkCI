helpers
theNonMetaClassOf: class
	^ (class respondsTo: #instanceSide)
		ifTrue: [ class instanceSide ]
		ifFalse: [ super theNonMetaClassOf: class ]