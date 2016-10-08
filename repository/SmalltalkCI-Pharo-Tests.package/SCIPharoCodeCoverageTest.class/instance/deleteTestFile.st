setup
deleteTestFile
	(SmalltalkCIPharo fileExists: self class coverageTestFile)
		ifTrue: [ self class coverageTestFile asFileReference delete ]