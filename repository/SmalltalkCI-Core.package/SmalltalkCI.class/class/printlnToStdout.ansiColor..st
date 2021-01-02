helpers
printlnToStdout: msg ansiColor: ansiColor
	"Compared to printToStdout:ansiColor, only print a single line without empty line in front"
	self stdout nextPutAll: ansiColor, msg, self ansiReset; cr; flush