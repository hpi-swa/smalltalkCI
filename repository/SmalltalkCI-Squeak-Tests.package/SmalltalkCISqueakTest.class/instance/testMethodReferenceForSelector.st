testing
testMethodReferenceForSelector
	| reference |
	reference := SmalltalkCISqueak methodReferenceFor: Object selector: #=.
	self assert: reference classSymbol equals: #Object.
	self assert: reference methodSymbol equals: #=