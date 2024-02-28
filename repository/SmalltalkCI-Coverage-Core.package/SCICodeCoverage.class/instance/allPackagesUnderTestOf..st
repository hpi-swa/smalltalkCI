helpers
allPackagesUnderTestOf: classes
	^ (classes
		select: [ :class | (self theMetaClassOf: class) includesSelector: #packageNamesUnderTest])
		gather: [ :class | (self theNonMetaClassOf: class) packageNamesUnderTest
			gather: [ :packageName | SmalltalkCI platformClass classesInPackage: packageName ]]