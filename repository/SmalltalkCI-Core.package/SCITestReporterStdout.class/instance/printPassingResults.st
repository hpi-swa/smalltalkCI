printing
printPassingResults
	| title |
	self newLine; printTravisFold: 'passing_tests' action: 'start'.
	title := '(', result passingTests asString, ' tests passed)'.
	self print: title; newLine.
	
	[ result results keysAndValuesDo: [ :class :results | | passing |
		passing := results select: [ :result | result passed ].
		passing ifNotEmpty: [
			self printTitle: class asString.
			passing do: [ :result | self printPass: result ] ] ]
	] ensure: [ self printTravisFold: 'passing_tests' action: 'end' ]