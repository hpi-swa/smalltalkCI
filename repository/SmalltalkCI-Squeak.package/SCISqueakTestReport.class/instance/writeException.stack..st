reporting
writeException: error stack: stack.
	self
		write: (self encode: error class name);
		write: '" message="', (self encode: (error messageText ifNil: [ error description ])), '">';
		write: (self encode: stack)