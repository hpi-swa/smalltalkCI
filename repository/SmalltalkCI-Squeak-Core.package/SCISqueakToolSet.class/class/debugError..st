debugging
debugError: anError
	"Print out a sensible stack trace and bail"
	| problemPlace s |
	problemPlace := anError signalerContext.
	s := FileStream stderr.
	(anError isKindOf: MessageNotUnderstood) ifTrue: [
		s
			nextPutAll: anError messageText; cr;
			nextPutAll: problemPlace sender methodNode printString; cr].
	(problemPlace stackOfSize: 20) do: [:ctx | s cr. ctx printOn: s].
	s flush.

	"Close image and save it for debugging purposes"
	SmalltalkCISqueak closeAndSaveImage