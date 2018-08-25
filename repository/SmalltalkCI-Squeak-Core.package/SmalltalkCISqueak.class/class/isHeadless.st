helpers
isHeadless
	^ Smalltalk vm options includesAnyOf: #('-headless' '-nodisplay' '-vm-display-null')