printing
printException: aType result: aResult
	| error |
	error := aResult testError.
	
	self
		tab; tab; print: '<', aType, ' type="', (self encode: error class name);
		print: '" message="', (self encode: (error messageText ifNil: [ error description ])), '">'.
	aResult testStack ifNotNil: [
		self
			lf; print: (self encode: aResult testStack);
			tab; tab ].
	self print: '</', aType, '>'; lf