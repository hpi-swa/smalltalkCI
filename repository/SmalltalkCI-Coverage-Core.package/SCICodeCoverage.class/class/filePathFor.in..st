helpers
filePathFor: aMethodReference in: directoryName
	"Generates the filename for the file where the method related to aMethodReference is specified in.
	directoryName (a String) states the subfolder in the projectDirectory where the method comes from."
	| selector class package behaviorType instanceOrClass |
	selector := aMethodReference selector.
	class := aMethodReference actualClass.
	package := self packageNameForMethod: aMethodReference.
	behaviorType := (self packageNameForClass: class) = package
		ifFalse: ['extension']
		ifTrue:
			[class isTrait
				ifTrue: ['trait']
				ifFalse: ['class']].
	instanceOrClass := class isMeta
		ifTrue: ['class']
		ifFalse: ['instance'].
	^ directoryName, SmalltalkCI pathNameDelimiter,
		package, '.package', SmalltalkCI pathNameDelimiter,
		class instanceSide name, '.', behaviorType , SmalltalkCI pathNameDelimiter,
		instanceOrClass, SmalltalkCI pathNameDelimiter,
		(self fileNameForSelector: selector), '.st'