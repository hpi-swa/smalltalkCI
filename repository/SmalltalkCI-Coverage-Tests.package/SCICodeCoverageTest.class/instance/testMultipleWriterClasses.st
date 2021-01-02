testing-writer
testMultipleWriterClasses

	| writers |
	self platformSupportsCoverageTesting ifFalse: [^ self].
	
	writers := SmalltalkCI codeCoverageClass new
		spec: self class allFormatsSpec;
		coverageWriters.
		
	self assert: {SCICoverallsWriter. SCIStdoutCoverageWriter. SCILcovWriter} equals: (writers collect: #class).