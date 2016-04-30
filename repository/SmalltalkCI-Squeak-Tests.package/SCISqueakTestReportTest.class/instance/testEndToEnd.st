testing
testEndToEnd
	| testStream contents result isUsingSCISqueakTranscript |
	self assert: false equals: (SmalltalkCISqueak fileExists: self class expectedFileName).
	
	isUsingSCISqueakTranscript := (Transcript isKindOf: SCISqueakTranscript).
	isUsingSCISqueakTranscript ifTrue: [ SCISqueakTranscript uninstall ].
	result := SCISqueakTestReport runClasses: {SCIExcludedTests} named: self class suiteName.
	isUsingSCISqueakTranscript ifTrue: [ SCISqueakTranscript install ].

	self assert: 3 equals: result suiteFailures.
	self assert: 1 equals: result suiteErrors.
	self assert: 2 equals: result suitePassing.
	self assert: 6 equals: result suiteTotal.
	self assert: result hasFailuresOrErrors equals: true.
	
	testStream := StandardFileStream fileNamed: self class expectedFileName.
	testStream := MultiByteFileStream newFrom: testStream.
	contents := testStream contents.
	testStream close.
	
	self class expectedSubStrings do: [ :subString |
		self assert: (contents includesSubString: subString) ].
	
	self assert: true equals: (SmalltalkCISqueak fileExists: self class expectedFileName).