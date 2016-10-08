printing
printResults
	runner results keysAndValuesDo: [ :class :results |
		results do: [ :result |
			self printResult: result ] ]