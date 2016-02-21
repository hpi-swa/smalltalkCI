SmalltalkCI subclass: #SmalltalkCIGemstone
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkCI-Gemstone'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SmalltalkCIGemstone class
	instanceVariableNames: ''!

!SmalltalkCIGemstone class methodsFor: 'compatibility' stamp: 'fn 1/31/2016 17:58'!
isPlatformCompatible
	Smalltalk at: #'SystemVersion'
		ifPresent: [ :cl | ^ false ].
	^ true! !

!SmalltalkCIGemstone class methodsFor: 'compatibility' stamp: 'EstebanLorenzano 1/26/2016 17:36'!
platformSymbol
	^ #gemstone! !


!SmalltalkCIGemstone class methodsFor: 'bootstrapping' stamp: 'fn 1/31/2016 19:30'!
installMetacello
	(Smalltalk at: #Gofer) new
		package: 'GsUpgrader-Core';
		url: 'http://ss3.gemtalksystems.com/ss/gsUpgrader';
		load.
	(Smalltalk at: #GsUpgrader) upgradeMetacello! !


!SmalltalkCIGemstone class methodsFor: 'helpers' stamp: 'fn 1/31/2016 21:39'!
getAuthor
	^ (Smalltalk at: #MCPlatformSupport) authorInitialsPerSe! !

!SmalltalkCIGemstone class methodsFor: 'helpers' stamp: 'travisCI 1/27/2016 17:03'!
isHeadless
	^ true! !
