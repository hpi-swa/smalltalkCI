tests-writer
testCoverallsWriterClass

	self platformSupportsCoverageTesting ifFalse: [^ self].
	
	self assertWriterUsesFormat: #coveralls forSpec: self class coverallsSpec