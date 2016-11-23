helpers
methodsToCoverForCategories
	^ self coverageAt: #categories
		do: [ :categories | | classes |
			classes := categories gather: [ :categoryName |
				SmalltalkCI classesInCategory: categoryName ].
			self class methodReferencesFor: 
				(classes collect: [ :cls | cls theNonMetaClass]),
				(classes collect: [ :cls | cls theMetaClass ]) ]