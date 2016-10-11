helpers
getAuthor
	^ (Smalltalk at: #Author) fullNamePerSe ifNil: [ ^ '' ]