tests-writer
testLcovWriterClass

	self platformSupportsCoverageTesting ifFalse: [^ self].
	
	self assertWriterUsesFormat: #lcov forSpec: self class lcovSpec.