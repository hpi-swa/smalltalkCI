executing
loadRepositoryFor: aSmalltalkCI
	^ self repository
		ifNil: [ 'filetree://', aSmalltalkCI projectDirectory, '/', self directory ]