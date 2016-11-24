printing
printException: aResult
	| error type |
	error := aResult testError.
	type := aResult errored
		ifTrue: [ 'error' ]
		ifFalse: [ 'failure' ].
	
	self
		tab; tab; print: '<', type, ' type="', (self encode: error class name);
		print: '" message="', (self encode: (error messageText ifNil: [ error description ])), '">'.
	aResult stack ifNotNil: [
		self
			newLine; print: (self encode: aResult stack);
			tab; tab ].
	self print: '</', type, '>'; newLine