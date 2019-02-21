helpers
allClassesNotUnderTestOf: classes
	^ ((classes
		select: [ :class | (self theMetaClassOf: class) includesSelector: #classNamesNotUnderTest])
		gather: [ :class | (self theNonMetaClassOf: class) classNamesNotUnderTest
			collect: [ :className | Smalltalk classNamed: className ]])
				reject: [ :ea | ea isNil ]