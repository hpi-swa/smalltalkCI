'From Squeak6.0 of 5 July 2022 [latest update: #22104] on 26 August 2026 at 1:04:35 am'!

!Latin1Environment class methodsFor: 'accessing' stamp: 'eem 12/14/2020 18:36'!
systemConverterClass

	| platformName |
	platformName := Smalltalk platformName.
	platformName = 'Win32' ifTrue:
		[^self win32VMUsesUnicode
			ifTrue: [UTF8TextConverter]
			ifFalse: [ISO88591TextConverter]].
	platformName = 'Mac OS' ifTrue:
		[^((Smalltalk osVersion indexOf: $.) > 4 "i.e. not 9xx.n, but 10xx.n, 11xx.n etc")
			ifTrue: [UTF8TextConverter]
			ifFalse: [MacRomanTextConverter]].
	platformName = 'unix' ifTrue:
		[^UTF8TextConverter].
	^MacRomanTextConverter! !

!LanguageEnvironment class methodsFor: 'private' stamp: 'nice 12/9/2019 13:54'!
win32VMUsesUnicode
	| buildDate ind date vmHead |
	vmHead := Smalltalk vmVersion.
	vmHead ifNil: [^ false].
	(vmHead beginsWith: 'Open Smalltalk')
		ifTrue: [ ^ true ].
	buildDate := Smalltalk buildDate.
	buildDate ifNil: [^ false].
	ind := buildDate indexOfSubCollection: 'on'.
	date := Date readFromString: (buildDate copyFrom: ind+3 to: buildDate size).
	(vmHead beginsWith: 'Croquet') ifTrue: [
		^ date >= (Date readFromString: '1 Feb 2007')
	].
	(vmHead beginsWith: 'Squeak') ifTrue: [
		^ date >= (Date readFromString: '5 June 2007')
	].
	^ false.

"LanguageEnvironment win32VMUsesUnicode"! !
