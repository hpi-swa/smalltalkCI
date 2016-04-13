coverage
absoluteFileNameFor: aCompiledMethod in: aDirectoryName 
	^ (self projectDirectory , self class slash , (self fileNameFor: aCompiledMethod in: aDirectoryName))