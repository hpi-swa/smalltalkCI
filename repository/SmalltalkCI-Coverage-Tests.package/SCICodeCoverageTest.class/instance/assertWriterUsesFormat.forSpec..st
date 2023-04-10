tests-writer
assertWriterUsesFormat: coverageFormat forSpec: aSpec

	|writer|
	writer := SmalltalkCI codeCoverageClass new
		spec: aSpec;
		coverageWriter.
	
	self assert: coverageFormat equals: writer class coverageFormat.