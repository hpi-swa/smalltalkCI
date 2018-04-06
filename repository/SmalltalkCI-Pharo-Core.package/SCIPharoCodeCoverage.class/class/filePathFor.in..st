helpers
filePathFor: aMethodReference in: aDirectoryName
	^ (self isInTonelFormatCodeLocatedAt: aDirectoryName)
		ifTrue: [ | class packageName |
			class := aMethodReference actualClass.
			packageName := self packageNameForClass: class.
			^ aDirectoryName , SmalltalkCI pathNameDelimiter , packageName , SmalltalkCI pathNameDelimiter , class name , '.class.st' ]
		ifFalse: [ super filePathFor: aMethodReference in: aDirectoryName ]