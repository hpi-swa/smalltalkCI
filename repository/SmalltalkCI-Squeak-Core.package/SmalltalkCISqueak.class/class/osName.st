environment
osName 
	"After Squeak version 3.6, #platformName was moved to SmalltalkImage Some
	versions of Pharo move this to OSPlatform and issue deprecation warnings
	about the other usages. The original idiom (Squeak 3.6 and earlier) is the sensible
	default, but here we attempt to support other implementations if the sensible
	default is not available."

	"OSProcess platformName"

	(Smalltalk respondsTo: #platformName)
		ifTrue: [^ Smalltalk platformName].
	self isPharo3AndLater
		ifTrue: [ ^ (Smalltalk perform: #os) name ].
	^ (((Smalltalk hasClassNamed: #OSPlatform)
			and: [(Smalltalk at: #OSPlatform)
					respondsTo: #platformName])
		ifTrue: [Smalltalk at: #OSPlatform]
		ifFalse: [((Smalltalk classNamed: 'SmalltalkImage')
				ifNil: [^ Smalltalk osVersion]) current]) platformName