build-status
ensureNoExistingBuildStatusFile
	(self fileExists: self buildStatusFile)
		ifTrue: [ SCIError signal: 'A build status file already exists.' ]