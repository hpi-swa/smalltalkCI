private
coverageDictFor: aCompiledMethod in: aDirectoryName
	| fileName coverageSymbol |
	fileName := (self fileNameFor: aCompiledMethod in: aDirectoryName).
	coverageSymbol := aCompiledMethod hasRun ifTrue: [ 1 ] ifFalse: [ 0 ].
	^ Dictionary newFrom: {
			('name' -> fileName) .
			('source_digest' -> (self md5ForFile: fileName)) .
			('coverage' -> (Array new: (self linesOfFile: fileName) withAll: coverageSymbol))}