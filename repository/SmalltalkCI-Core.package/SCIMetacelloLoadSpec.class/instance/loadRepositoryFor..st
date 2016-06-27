executing
loadRepositoryFor: aSmalltalkCI
	^ self repository
		ifNil: [ 'filetree://', aSmalltalkCI projectDirectory, SmalltalkCI pathNameDelimiter, self directory ]