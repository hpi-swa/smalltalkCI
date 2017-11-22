helpers
allClassesToCover
	| classes classesNotUnderTest |
	classes := Set new
		addAll: self classesToCover;
		addAll: self classesToCoverForCategories;
		addAll: self classesToCoverForPackages;
		yourself.

	"Add packagesUnderTest"
	classes addAll: ((classes
		select: [ :class | class theMetaClass includesSelector: #packageNamesUnderTest])
		gather: [ :class | class theNonMetaClass packageNamesUnderTest
			gather: [ :packageName | SmalltalkCI classesInPackage: packageName ]]).

	"Expand set so that it includes classes and their metaclasses"
	classes := self classesAndMetaclassesOf: classes.

	"Remove classesNotUnderTest"
	classesNotUnderTest := (classes
		select: [ :class | class theMetaClass includesSelector: #classNamesNotUnderTest])
		gather: [ :class | class theNonMetaClass classNamesNotUnderTest
			collect: [ :className | Smalltalk classNamed: className ]].
	classes removeAll: (self classesAndMetaclassesOf: classesNotUnderTest asSet).

	^ classes