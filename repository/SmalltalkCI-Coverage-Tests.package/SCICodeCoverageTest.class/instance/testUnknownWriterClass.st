testing-writer
testUnknownWriterClass

	self platformSupportsCoverageTesting ifFalse: [^ self].
	
	self should: [
		SmalltalkCI codeCoverageClass new
			spec: self class unknownWriterSpec;
			coverageWriters]
		raise: SCIError.