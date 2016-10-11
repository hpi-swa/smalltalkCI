testing
testCoverageHelpers
	| testStream |
	self assert: (SmalltalkCIPharo fileExists: self class coverageTestFile) equals: false.
	testStream := StandardFileStream fileNamed: self class coverageTestFile.
	testStream := MultiByteFileStream newFrom: testStream.
	testStream nextPutAll: 'First line', String cr, 'Second line'.
	testStream close.
	self inst projectDirectory: '.'.
	self assert: (self inst linesForFile: self class coverageTestFile) equals: 2.
	self assert: (self inst md5ForFile: self class coverageTestFile) equals: 'ac52b72be23970e756614f929e640fba'
	