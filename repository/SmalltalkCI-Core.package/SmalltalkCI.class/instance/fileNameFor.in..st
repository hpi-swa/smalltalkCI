coverage
fileNameFor: aCompiledMethod in: aDirectoryName 
	"Generates the filename for the file where the method related to aCompiledMethod is specified in.
	aDirectoryName (a String) states the subfolder in the projectDirectory where the method comes from."
	| method class package instanceOrClass |
	method := aCompiledMethod selector.
	class := aCompiledMethod methodClass.
	class isMeta
		ifTrue: [ instanceOrClass := 'class' ]
		ifFalse: [ instanceOrClass := 'instance' ].
	package := self class packageNameForClass: class.
	^ aDirectoryName, self class slash,
		package, '.package', self class slash,
		class name, '.class', self class slash,
		instanceOrClass, self class slash,
		(method asString replaceAll: $: with: $.), '.st'