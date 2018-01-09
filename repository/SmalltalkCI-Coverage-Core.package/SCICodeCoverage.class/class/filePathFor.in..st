helpers
filePathFor: aMethodReference in: aDirectoryName 
	"Generates the filename for the file where the method related to aCompiledMethod is specified in.
	aDirectoryName (a String) states the subfolder in the projectDirectory where the method comes from."
	| method class package instanceOrClass |
	method := aMethodReference selector.
	class := aMethodReference actualClass.
	class isMeta
		ifTrue: [ instanceOrClass := 'class' ]
		ifFalse: [ instanceOrClass := 'instance' ].
	package := self packageNameForClass: class.
	^ aDirectoryName, SmalltalkCI pathNameDelimiter,
		package, '.package', SmalltalkCI pathNameDelimiter,
		class name, '.class', SmalltalkCI pathNameDelimiter,
		instanceOrClass, SmalltalkCI pathNameDelimiter,
		(method asString replaceAll: $: with: $.), '.st'