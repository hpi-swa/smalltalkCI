private
tonelFilePathFor: class in: aDirectoryName
	| packageName |
	packageName := self packageNameForClass: class.
	^ aDirectoryName , SmalltalkCI pathNameDelimiter , packageName , SmalltalkCI pathNameDelimiter , class name , '.class.st'