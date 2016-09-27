printing
printTestTitle: aResult
	self cr; print: (aResult testCase asString), ' (', aResult testTime asString, 'ms)'; cr