asserting
assert: cmd syntax: syntaxString comment: commentString
	| commentPart expectedSyntax expectedComment |
	expectedSyntax := syntaxString withUnixLineEndings.
	expectedComment := commentString withUnixLineEndings.
	self assert: cmd comment asString equals: expectedComment.
	self assert: cmd instruction asString equals: expectedSyntax.
	commentPart := expectedComment 
		ifNotEmpty: [ expectedComment, Character lf asString ]
		ifEmpty: [ '' ].
	self assert: cmd printString equals: commentPart, expectedSyntax