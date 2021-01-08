executing-deprecated
loadRepositoryFor: aSmalltalkCI
	SmalltalkCI deprecated: 'Use repository and repositoryUrlIn: instead'.
	^ self repository
		ifNil: [ 'filetree://', aSmalltalkCI projectDirectory, SmalltalkCI pathNameDelimiter, self directory ]
