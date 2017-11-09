executing
loadRepositoryFrom: aProjectDirectory
	^ self repository
		ifNil: [ 'filetree://', aProjectDirectory, SmalltalkCI pathNameDelimiter, self directory ]