reporting
writeException: error stack: stack.
	self
		write: (self encode: error class name);
		write: '" message="'; nextPutAll: (self encode: (error messageText ifNil: [ error description ]));
		write: '">';
		write: (self encode: stack)