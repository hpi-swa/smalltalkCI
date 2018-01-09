compatibility
readOnlyFileNamed: aFilename do: aBlock
	^ aFilename asFileReference readStreamDo: aBlock