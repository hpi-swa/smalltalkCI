helpers
allClassesToCover
	| classes ignoredClasses |
	classes := self allClassesFromSpec.
	classes addAll: (self allPackagesUnderTestOf: classes).
	"Expand set so that it includes classes and their metaclasses"
	classes := self classesAndMetaclassesOf: classes.
	
	ignoredClasses := (self allClassesNotUnderTestOf: classes) asSet.
	"Ignore system classes to avoid infinite recursions during coverage testing"
	ignoredClasses addAll: (SmalltalkCI platformClass classesForPackages: self class ignoredPackages).

	classes removeAllFoundIn: (self classesAndMetaclassesOf: ignoredClasses).

	^ classes