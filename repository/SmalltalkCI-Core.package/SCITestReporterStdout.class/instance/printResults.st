printing
printResults
	runner results keysAndValuesDo: [ :class :results |
		self printClassTitle: class.
		results do: [ :result |
			self printResult: result ] ]