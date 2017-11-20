build-status
reportToBuildStatusFile: aMessage
	(self forceNewFileNamed: self buildStatusFile)
		nextPutAll: aMessage;
		close