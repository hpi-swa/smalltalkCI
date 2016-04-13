coverage
writeCoverageReport: anArray
	(StandardFileStream forceNewFileNamed: SmalltalkCI coverageFilename)
		nextPutAll: (STON toJsonString: anArray);
		close.