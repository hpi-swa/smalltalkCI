printing
printResults
	result results keysAndValuesDo: [ :class :results |
		results do: [ :result |
			self printResult: result ] ]