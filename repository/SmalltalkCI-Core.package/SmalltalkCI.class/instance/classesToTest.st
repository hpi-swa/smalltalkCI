accessing
classesToTest
	| classes |
	self explicitTestKeys
		do: [ :key | 
			(spec testing includesKey: key)
				ifTrue: [ ^ self class testClassesFrom: spec testing ] ].
	classes := Set new.
	self compatibleLoadSpecs do: [ :each | classes addAll: each testClasses ].
	spec testing at: #'include'
		ifPresent: [ :includeDict | classes addAll: (self class testClassesFrom: includeDict) ].
	spec testing at: #'exclude'
 		ifPresent: [ :excludeDict | classes removeAllFoundIn: (self class testClassesFrom: excludeDict) ].
	^ classes