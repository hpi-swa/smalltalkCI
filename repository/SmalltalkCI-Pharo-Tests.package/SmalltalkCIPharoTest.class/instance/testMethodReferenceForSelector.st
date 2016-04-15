testing
testMethodReferenceForSelector
	| reference |
	reference := SmalltalkCIPharo methodReferenceFor: Object selector: #=.
	self assert: reference className equals: #Object.
	self assert: reference name equals: #=