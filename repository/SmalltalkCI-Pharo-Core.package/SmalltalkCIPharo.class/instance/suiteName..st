accessing-deprecated
suiteName: aName
	SmalltalkCI deprecated: 'Use #name option to override suite name'.
	self spec ifNotNil: [ :spec | spec name: aName ]