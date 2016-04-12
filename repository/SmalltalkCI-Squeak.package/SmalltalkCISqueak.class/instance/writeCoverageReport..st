private
writeCoverageReport: anArray
	(StandardFileStream fileNamed: (self projectDirectory, FileDirectory slash, '.coverageReport'))
		truncate;
		nextPutAll: (STON toJsonString: anArray).