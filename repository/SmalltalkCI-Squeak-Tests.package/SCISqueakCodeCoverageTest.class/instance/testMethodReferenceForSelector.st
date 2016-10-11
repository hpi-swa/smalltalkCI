testing
testMethodReferenceForSelector
	| reference |
	reference := SCISqueakCodeCoverage methodReferenceFor: Object selector: #=.
	self assert: reference classSymbol equals: #Object.
	self assert: reference methodSymbol equals: #=