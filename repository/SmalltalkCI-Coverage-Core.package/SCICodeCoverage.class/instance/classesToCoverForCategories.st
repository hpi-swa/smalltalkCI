helpers
classesToCoverForCategories
	^ self coverageAt: #categories do: [ :categoryNames |
		  SmalltalkCI platformClass classesForCategories:
			  (self filterLegalNames: categoryNames) ]