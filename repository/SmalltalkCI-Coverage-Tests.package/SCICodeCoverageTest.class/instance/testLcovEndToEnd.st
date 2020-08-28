testing
testLcovEndToEnd
	| stringStream |
	self platformSupportsCoverageTesting ifFalse: [ ^ self ].
	
	stringStream := WriteStream on: ''.
	SCILcovWriter new
		spec: self class lcovSpec;
		stream: stringStream;
		projectDirectory: 'projDir';
		writeLineDataByFiles: self class mockLineCoverage.

	self assert: self class lcovEndToEndOutput withUnixLineEndings
		equals: stringStream contents.