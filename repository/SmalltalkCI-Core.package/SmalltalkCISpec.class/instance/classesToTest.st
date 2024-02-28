helpers
classesToTest
	| classes |
	SmalltalkCI explicitTestKeys
		do: [ :key | 
			(self testing includesKey: key)
				ifTrue: [ ^ SmalltalkCI platformClass classesFrom: self testing ] ].
	classes := OrderedCollection new.
	(self testing at: #'allTestCases' ifAbsent: [ false ]) = true
		ifTrue: [ classes addAll: TestCase allSubclasses ]
		ifFalse: [ "By default, add all classes that have been loaded by compatible LoadSpecs"
			self compatibleLoadSpecs do: [ :each | classes addAll: each loadedClasses ] ].
	self testing at: #'include'
		ifPresent: [ :includeDict | classes addAll: (SmalltalkCI platformClass platformClass classesFrom: includeDict) ].
	self testing at: #'exclude'
 		ifPresent: [ :excludeDict | classes removeAllFoundIn: (SmalltalkCI platformClass classesFrom: excludeDict) ].
	^ classes select: [ :cl | cl inheritsFrom: TestCase ]
