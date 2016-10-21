printing
printResult: aResult
	self
		tab; print: '<testcase classname="';
		print: (self encode: (aResult testCase class category copyReplaceAll: '-' with: '.'));
		print: '.', (self encode: aResult testCase class name), '" ';
		print: 'name="', (self encode: aResult testCase selector), '" ';
		print: 'time="', (aResult time / 1000.0) asString, '">'.
	aResult passed ifFalse: [
		self newLine.
		super printResult: aResult.
		self tab ].
	self print: '</testcase>'; newLine