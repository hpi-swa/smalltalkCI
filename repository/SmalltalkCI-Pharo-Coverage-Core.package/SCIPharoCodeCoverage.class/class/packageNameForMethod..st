compatibility
packageNameForMethod: aMethodReference

	^ (aMethodReference compiledMethod methodClass packages detect: [:each | each includesSelector: aMethodReference compiledMethod selector ofClass: aClass ]) packageName