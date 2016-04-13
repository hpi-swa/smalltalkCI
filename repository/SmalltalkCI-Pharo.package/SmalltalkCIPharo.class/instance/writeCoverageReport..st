coverage
writeCoverageReport: anArray
	(StandardFileStream forceNewFileNamed: 'coverage.json')
		nextPutAll: (STON toJsonString: anArray);
		close.