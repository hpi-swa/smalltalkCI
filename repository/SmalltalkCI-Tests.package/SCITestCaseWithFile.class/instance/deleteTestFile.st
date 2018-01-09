file-handling
deleteTestFile
	(SmalltalkCI fileExists: self fullTestFilePath)
		ifTrue: [ SmalltalkCI deleteFile: self fullTestFilePath ]