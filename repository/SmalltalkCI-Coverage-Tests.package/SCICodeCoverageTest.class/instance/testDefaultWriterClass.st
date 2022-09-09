tests-writer
testDefaultWriterClass

	self platformSupportsCoverageTesting ifFalse: [^ self].
	
	self assertWriterUsesFormat: #coveralls forSpec: self class endToEndSpec