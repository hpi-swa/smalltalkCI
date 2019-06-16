helpers
theMetaClassOf: class
	^ (class respondsTo: #classSide)
		ifTrue: [ class classSide ]
		ifFalse: [ super theMetaClassOf: class ]