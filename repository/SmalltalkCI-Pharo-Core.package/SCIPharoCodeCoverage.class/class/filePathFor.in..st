helpers
filePathFor: aMethodReference in: aDirectoryName
	^ (self isInTonelFormatCodeLocatedAt: aDirectoryName)
		ifTrue: [ self tonelFilePathFor: aMethodReference actualClass in: aDirectoryName ]
		ifFalse: [ super filePathFor: aMethodReference in: aDirectoryName ]