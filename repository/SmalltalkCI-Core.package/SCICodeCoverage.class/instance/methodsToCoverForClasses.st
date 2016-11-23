helpers
methodsToCoverForClasses
	^ self coverageAt: #classes
		do: [ :classes | self class methodReferencesFor: classes ]