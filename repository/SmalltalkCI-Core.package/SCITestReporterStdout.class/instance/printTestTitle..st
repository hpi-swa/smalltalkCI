printing
printTestTitle: aResult
	| time |
	time := SmalltalkCI stringFor: aResult testTime maxDecimalPlaces: 0.
	self print: aResult testName, ' (', time, 'ms)';
		newLine