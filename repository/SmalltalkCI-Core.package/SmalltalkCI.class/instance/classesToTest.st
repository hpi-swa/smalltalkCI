accessing
classesToTest
	| classes |
	self explicitTestKeys
		do: [ :key | 
			(spec testing includesKey: key)
				ifTrue: [ ^ self class classesFrom: spec testing ] ].
	classes := Set new.
	self compatibleLoadSpecs do: [ :each | classes addAll: each loadedClasses ].
	spec testing at: #'include'
		ifPresent: [ :includeDict | classes addAll: (self class classesFrom: includeDict) ].
	spec testing at: #'exclude'
 		ifPresent: [ :excludeDict | classes removeAllFoundIn: (self class classesFrom: excludeDict) ].
	^ classes