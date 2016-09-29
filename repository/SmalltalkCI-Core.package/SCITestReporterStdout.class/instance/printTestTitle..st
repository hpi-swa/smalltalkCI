printing
printTestTitle: aResult
	aResult testCase printOn: stream.
	self print: ' (', (SmalltalkCI stringFor: aResult testTime maxDecimalPlaces: 0), 'ms)'; newLine