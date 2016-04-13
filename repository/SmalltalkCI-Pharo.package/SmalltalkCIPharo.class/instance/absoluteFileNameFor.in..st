coverage
absoluteFileNameFor: aCompiledMethod in: aDirectoryName 
	^ (self projectDirectory, '/', (self fileNameFor: aCompiledMethod in: aDirectoryName))