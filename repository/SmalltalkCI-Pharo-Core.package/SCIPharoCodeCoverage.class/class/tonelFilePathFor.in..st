private
tonelFilePathFor: class in: aDirectoryName
	| packageName packagePath |
	packageName := self packageNameForClass: class.
	packagePath := aDirectoryName , SmalltalkCI pathNameDelimiter , packageName.
	^ (SmalltalkCI fileExists: packagePath)
		ifTrue: [ packagePath , SmalltalkCI pathNameDelimiter , class name , '.class.st' ]
		ifFalse: [ "This can be an extension. Currently not supported" NotFound signal ]