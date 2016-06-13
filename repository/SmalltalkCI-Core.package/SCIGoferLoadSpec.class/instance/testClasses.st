testing
testClasses
	^ self loadedClasses asOrderedCollection select: [ :cl | cl inheritsFrom: TestCase ]