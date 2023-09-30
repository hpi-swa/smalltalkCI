compatibility
packageNameForMethod: aMethodReference
	| aClass |
	aClass := aMethodReference compiledMethod methodClass.
	^ (aClass packages detect: [:each | each includesSelector: aMethodReference compiledMethod selector ofClass: aClass ]) name