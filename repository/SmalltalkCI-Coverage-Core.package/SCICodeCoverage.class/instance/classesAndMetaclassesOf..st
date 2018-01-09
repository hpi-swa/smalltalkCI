helpers
classesAndMetaclassesOf: classes
	^ (classes collect: [ :cls | cls theNonMetaClass]),
		(classes collect: [ :cls | cls theMetaClass ])