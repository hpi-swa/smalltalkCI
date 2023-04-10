helpers
classesAndMetaclassesOf: classes
	^ (classes collect: [ :cls | self theNonMetaClassOf: cls ])
		, (classes collect: [ :cls | self theMetaClassOf: cls ])