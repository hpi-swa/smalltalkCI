helpers
deleteFile: aFilename
	(FileDirectory on: aFilename)
		deleteFileNamed: FileDirectory default pathName, '/', aFilename
		ifAbsent: [(CannotDeleteFileException new
			messageText: 'Could not delete the old version of file ' , aFilename) signal].