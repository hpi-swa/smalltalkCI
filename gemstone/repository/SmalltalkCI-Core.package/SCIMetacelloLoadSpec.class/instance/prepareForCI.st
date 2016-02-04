testing
prepareForCI
	self originalAuthor: (Smalltalk at: #SmalltalkCI) getAuthor.
	self class setAuthor: self class testAuthor