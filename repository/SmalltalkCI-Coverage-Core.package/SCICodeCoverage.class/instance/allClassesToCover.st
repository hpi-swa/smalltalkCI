helpers
allClassesToCover
	| classes |
	classes := self allClassesFromSpec.
	classes addAll: (self allPackagesUnderTestOf: classes).
	classes removeAllFoundIn: (self allClassesNotUnderTestOf: classes) asSet.
	"Expand set so that it includes classes and their metaclasses"
	^ self classesAndMetaclassesOf: classes