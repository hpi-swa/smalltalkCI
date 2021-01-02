executing
filetreeRepositoryIn: aProjectDirectory
	| projectLocation |
	projectLocation := aProjectDirectory, SmalltalkCI pathNameDelimiter, self directory.
	^ (self filetreeFormatIn: projectLocation), '://', projectLocation