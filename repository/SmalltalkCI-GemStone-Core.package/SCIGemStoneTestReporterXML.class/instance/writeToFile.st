initialize-release
writeToFile
	| path file |
	path := self projectDirectory, SmalltalkCIGemstone pathNameDelimiter, runner suite name , '.xml'.
	file := BinaryOrTextFile openWrite: path.
 	file nextPutAll: stream contents.
	file close