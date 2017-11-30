helpers
executionClass
	^ self isCoverageTestingEnabled
		ifTrue: [ self class codeCoverageClass ]
		ifFalse: [ self class ]