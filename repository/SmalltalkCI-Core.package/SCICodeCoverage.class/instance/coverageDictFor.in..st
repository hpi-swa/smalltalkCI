helpers
coverageDictFor: aCompiledMethod in: aDirectoryName
	| filePath coverageSymbol |
	filePath := (self filePathFor: aCompiledMethod in: aDirectoryName).
	coverageSymbol := aCompiledMethod hasRun
		ifTrue: [ 1 ]
		ifFalse: [ aCompiledMethod isAbstract
				ifTrue: [ nil ]
				ifFalse: [ 0 ] ].
	^ Dictionary newFrom: {
			('name' -> (self relativePathOf: filePath)).
			('source_digest' -> (self md5Of: filePath)).
			('coverage' -> (Array new: (self linesOf: filePath) withAll: coverageSymbol))}
