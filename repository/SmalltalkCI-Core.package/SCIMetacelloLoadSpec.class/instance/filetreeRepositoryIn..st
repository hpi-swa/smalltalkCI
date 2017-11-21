executing
filetreeRepositoryIn: aProjectDirectory
	^ 'filetree://', aProjectDirectory, SmalltalkCI pathNameDelimiter, self directory