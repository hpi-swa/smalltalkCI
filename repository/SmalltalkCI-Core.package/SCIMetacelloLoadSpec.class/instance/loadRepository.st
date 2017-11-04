executing
loadRepository
	^ self repository
		ifNil: [ 'filetree://', SmalltalkCI projectDirectory, SmalltalkCI pathNameDelimiter, self directory ]