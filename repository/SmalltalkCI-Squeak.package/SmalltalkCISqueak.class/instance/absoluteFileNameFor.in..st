private
absoluteFileNameFor: aCompiledMethod in: aDirectoryName 
	^ (self projectDirectory , FileDirectory slash , (self fileNameFor: aCompiledMethod in: aDirectoryName))