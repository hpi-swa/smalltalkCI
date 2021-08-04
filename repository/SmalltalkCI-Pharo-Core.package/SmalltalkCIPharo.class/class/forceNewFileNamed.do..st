compatibility
forceNewFileNamed: aFile do: aBlock

	(Smalltalk at: #MultiByteFileStream) forceNewFileNamed: aFile do: aBlock