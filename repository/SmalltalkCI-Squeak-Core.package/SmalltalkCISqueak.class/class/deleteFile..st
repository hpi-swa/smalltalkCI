compatibility
deleteFile: aFilename
	(FileDirectory on: aFilename)
		deleteFileNamed: aFilename
		ifAbsent: [(CannotDeleteFileException new
			messageText: 'Could not delete the old version of ' , aFilename) signal]