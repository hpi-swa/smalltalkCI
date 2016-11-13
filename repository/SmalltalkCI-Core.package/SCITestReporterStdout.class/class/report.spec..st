as yet unclassified
report: aSCITestRunner spec: aSCISpec
	self
		basicNew
		initialize;
		runner: aSCITestRunner;
		hidePassingResults: aSCISpec hidePassingResults;
		report