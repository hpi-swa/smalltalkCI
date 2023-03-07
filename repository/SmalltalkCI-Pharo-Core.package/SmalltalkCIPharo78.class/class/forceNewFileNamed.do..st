compatibility
forceNewFileNamed: aFile do: aBlock
	aFile asFileReference writeStreamDo: [ :aStream | aBlock value: aStream ] 
