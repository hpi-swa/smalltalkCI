testing
testMethodReferenceForSelector
	| reference |
	reference := SCIPharoCodeCoverage methodReferenceFor: Object selector: #=.
	self assert: reference className equals: #Object.
	self assert: reference name equals: #=