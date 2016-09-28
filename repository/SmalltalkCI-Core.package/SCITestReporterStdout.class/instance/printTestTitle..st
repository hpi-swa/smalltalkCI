printing
printTestTitle: aResult
	aResult testCase printOn: stream.
	self print: ' (', aResult testTime rounded asString, 'ms)'; cr