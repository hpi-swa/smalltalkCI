private
tonelFilePathFor: class in: aDirectoryName
	| packageName packagePath |
	packageName := self packageNameForClass: class.
	packagePath := aDirectoryName , SmalltalkCI pathNameDelimiter , packageName.
	^ (SmalltalkCI fileExists: packagePath)
		ifTrue: [ packagePath , SmalltalkCI pathNameDelimiter , class name , '.class.st' ]
		ifFalse: [ packagePath , SmalltalkCI pathNameDelimiter , class name , '.extension.st' ]