executing
fileInFrom: aDirectory
	(BinaryOrTextFile openRead: aDirectory, SmalltalkCI pathNameDelimiter, self path) fileIn