private
fileNameFor: aCompiledMethod in: aDirectoryName 
	"Generates the filename for the file where the method related to aCompiledMethod is specified in.
	aDirectoryName (a String) states the subfolder in the projectDirectory where the method comes from."
	| method class package instanceOrClass |
	method := aCompiledMethod selector ifEmpty: [ aCompiledMethod searchForSelector ].
	class := aCompiledMethod methodClass.
	(class isKindOf: Metaclass)
		ifTrue: [
			instanceOrClass := 'class'.
			package := class soleInstance category ]
		ifFalse: [
			instanceOrClass := 'instance'.
			package := class category ].
	^ aDirectoryName , FileDirectory slash ,
		package , '.package' , FileDirectory slash ,
		class name , '.class' , FileDirectory slash ,
		instanceOrClass , FileDirectory slash ,
		(method asString replaceAll: $: with: $.) , '.st'