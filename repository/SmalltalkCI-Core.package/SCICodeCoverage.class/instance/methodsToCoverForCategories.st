helpers
methodsToCoverForCategories
	^ self coverageAt: #categories
		do: [ :categoryNames | | classes |
			classes := SmalltalkCI classesForCategories: categoryNames.
			self class methodReferencesFor: 
				(classes collect: [ :cls | cls theNonMetaClass]),
				(classes collect: [ :cls | cls theMetaClass ]) ]