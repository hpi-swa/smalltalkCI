executing
repositoryUrlIn: aProjectDirectory
	| projectLocation |
	projectLocation := aProjectDirectory, SmalltalkCI pathNameDelimiter, self directory.
	^ (self repositorySchemeIn: projectLocation), '://', projectLocation