printing
printNotPassingSummary
	runner results keysAndValuesDo: [ :class :results | | notPassing |
		notPassing := results select: [ :result | result passed not ].
		notPassing ifNotEmpty: [
			self printClassTitle: class.
			notPassing do: [ :result | self print: result ansiTitle; newLine ] ] ]