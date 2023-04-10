tests-writer
testUnknownWriterClass

	self platformSupportsCoverageTesting ifFalse: [^ self].
	
	self should: [
		SmalltalkCI codeCoverageClass new
			spec: self class unknownWriterSpec;
			coverageWriter]
		raise: SCIError.