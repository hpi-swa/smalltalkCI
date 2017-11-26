helpers
allPackagesUnderTestOf: classes
	^ (classes
		select: [ :class | class theMetaClass includesSelector: #packageNamesUnderTest])
		gather: [ :class | class theNonMetaClass packageNamesUnderTest
			gather: [ :packageName | SmalltalkCI classesInPackage: packageName ]]