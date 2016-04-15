helpers
isHeadless
	^ Smalltalk vm options includesAnyOf: #('-headless' '-nodisplay')