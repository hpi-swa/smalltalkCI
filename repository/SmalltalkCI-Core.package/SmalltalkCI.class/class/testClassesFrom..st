class organization
testClassesFrom: aDictionary
	^ (self classesFrom: aDictionary) select: [ :cl | cl inheritsFrom: TestCase ]