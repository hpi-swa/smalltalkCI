compatibility
forceNewFileNamed: aFile do: aBlock
	| stream |
	stream := BinaryOrTextFile openWrite: aFile.
	[ aBlock value: stream ] ensure: [ stream close ]