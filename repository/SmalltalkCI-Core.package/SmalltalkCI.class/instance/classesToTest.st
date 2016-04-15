accessing
classesToTest
	| classes |
	self explicitTestKeys
		do: [ :key | 
			(spec testing includesKey: key)
				ifTrue: [ ^ self class classesToTestFrom: spec testing ] ].
	classes := Set new.
	self compatibleLoadSpecs do: [ :each | classes addAll: each testClasses ].
	spec testing at: #'include'
		ifPresent: [ :includeDict | classes addAll: (self class classesToTestFrom: includeDict) ].
	spec testing at: #'exclude'
 		ifPresent: [ :excludeDict | classes removeAllFoundIn: (self class classesToTestFrom: excludeDict) ].
	^ classes