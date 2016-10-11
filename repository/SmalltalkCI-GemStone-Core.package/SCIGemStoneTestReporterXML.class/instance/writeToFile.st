initialize-release
writeToFile
	| file |
	file := BinaryOrTextFile openWrite: self xmlFilePath.
 	file nextPutAll: stream contents.
	file close