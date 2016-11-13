as yet unclassified
report: aSCITestRunner spec: aSCISpec
	self
		basicNew
		initialize;
		runner: aSCITestRunner;
		hidePassingTests: aSCISpec hidePassingTests;
		report