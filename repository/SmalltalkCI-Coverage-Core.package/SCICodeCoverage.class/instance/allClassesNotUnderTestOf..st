helpers
allClassesNotUnderTestOf: classes
	^ ((classes
		select: [ :class | class theMetaClass includesSelector: #classNamesNotUnderTest])
		gather: [ :class | class theNonMetaClass classNamesNotUnderTest
			collect: [ :className | Smalltalk classNamed: className ]])
				reject: [ :ea | ea isNil ]