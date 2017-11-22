helpers
classesToCoverForCategories
	^ self coverageAt: #categories
		do: [ :categoryNames | SmalltalkCI classesForCategories: categoryNames ]