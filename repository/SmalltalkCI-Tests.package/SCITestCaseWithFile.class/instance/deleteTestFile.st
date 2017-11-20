file-handling
deleteTestFile
	(SmalltalkCI platformClass fileExists: self fullTestFilePath)
		ifTrue: [ SmalltalkCI platformClass deleteFile: self fullTestFilePath ]