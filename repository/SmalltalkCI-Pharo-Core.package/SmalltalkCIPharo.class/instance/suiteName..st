accessing-deprecated
suiteName: aName
	SmalltalkCI deprecated: 'Use #name option to override suite name'.
	"Also remove spec: setter."
	suiteName := aName.
	self spec ifNotNil: [ :spec | spec name: aName ]