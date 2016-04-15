testing
testCoverageHelpers
	| fileName testStream |
	fileName := 'coverage_helpers.txt'.
	self assert: (SmalltalkCISqueak fileExists: fileName) equals: false.
	testStream := StandardFileStream fileNamed: fileName.
	testStream := MultiByteFileStream newFrom: testStream.
	testStream nextPutAll: 'First line', Character cr, 'Second line'.
	testStream close.
	self sci projectDirectory: '.'.
	self assert: (self sci linesForFile: fileName) equals: 2.
	self assert: (self sci md5ForFile: fileName) equals: 'ac52b72be23970e756614f929e640fba'.
	self class deleteFile: fileName
	