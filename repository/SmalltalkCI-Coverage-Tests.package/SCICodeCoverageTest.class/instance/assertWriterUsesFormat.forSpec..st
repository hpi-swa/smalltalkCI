testing-writer
assertWriterUsesFormat: coverageFormat forSpec: aSpec

	|writers|
	writers := SmalltalkCI codeCoverageClass new
		spec: aSpec;
		coverageWriters.
	
	self assert: coverageFormat equals: writers first class coverageFormat.