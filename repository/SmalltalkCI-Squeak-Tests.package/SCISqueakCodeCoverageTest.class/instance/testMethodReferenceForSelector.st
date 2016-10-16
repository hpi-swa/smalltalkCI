testing
testMethodReferenceForSelector
	| reference |
	reference := SmalltalkCI codeCoverageClass methodReferenceFor: Object selector: #=.
	self assert: reference classSymbol equals: #Object.
	self assert: reference methodSymbol equals: #=