testing
testMethodReferenceForSelector
	| reference |
	reference := SmalltalkCI codeCoverageClass methodReferenceFor: Object selector: #=.
	self assert: reference className equals: #Object.
	self assert: reference selector equals: #=