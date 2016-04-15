testing
testEndToEnd
	| expectedFilename testStream difference result |
	expectedFilename := 'excluded_tests.xml'.
	self assert: false equals: (SmalltalkCISqueak fileExists: expectedFilename).
	result := SCISqueakTestReport runClasses: {SCIExcludedTests} named: 'excluded_tests'.

	self assert: 2 equals: result suiteFailures.
	self assert: 1 equals: result suiteErrors.
	self assert: 2 equals: result suitePassing.
	self assert: 5 equals: result suiteTotal.
	self assert: result hasFailuresOrErrors equals: true.
	
	testStream := StandardFileStream fileNamed: expectedFilename.
	testStream := MultiByteFileStream newFrom: testStream.
	difference := testStream contents difference: self class expectedExcludedTestResult.
	self assert: difference withBlanksTrimmed size equals: 0.
	testStream close.
	
	self assert: true equals: (SmalltalkCISqueak fileExists: expectedFilename).
	SmalltalkCISqueakTest deleteFile: expectedFilename