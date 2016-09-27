printing
printTestTitle: aResult
	aResult testCase printOn: stream.
	self print: ' (', aResult testTime asString, 'ms)'; cr