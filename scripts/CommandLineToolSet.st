"https://github.com/frankshearar/squeak-ci/blob/master/CommandLineToolSet.st"!

'From Squeak4.5 of 16 April 2013 [latest update: #12597] on 23 April 2013 at 3:48:25 pm'!
StandardToolSet subclass: #CommandLineToolSet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tools-CommandLine'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

CommandLineToolSet class
	instanceVariableNames: ''!

!CommandLineToolSet class methodsFor: 'as yet unclassified' stamp: 'fbs 4/21/2013 16:02'!
debugError: anError
	"Print out a sensible stack trace and bail"
	| problemPlace s |
	problemPlace := anError signalerContext.
	s := FileStream stderr.
	(anError isKindOf: MessageNotUnderstood) ifTrue: [
		s
			nextPutAll: anError messageText; cr;
			nextPutAll: problemPlace sender methodNode printString; cr].
	(problemPlace stackOfSize: 20) do: [:ctx | s cr. ctx printOn: s].
	s flush.

	SmalltalkImage current snapshot: false andQuit: true! !

!CommandLineToolSet class methodsFor: 'as yet unclassified' stamp: 'fbs 5/08/2013 09:04'!
debugSyntaxError: anError
	| s |
	s := FileStream stderr.
	s nextPutAll: '----- Syntax error -----'; cr.
	s nextPutAll: anError errorCode; cr.
	s nextPutAll: '----- Syntax error -----'; cr.

	self debugError: anError! !

!CommandLineToolSet class methodsFor: 'as yet unclassified' stamp: 'fbs 4/21/2013 13:42'!
unload
	ToolSet unregister: self.! !

"register and make me the default"
ToolSet register: CommandLineToolSet.
ToolSet default: CommandLineToolSet.!

