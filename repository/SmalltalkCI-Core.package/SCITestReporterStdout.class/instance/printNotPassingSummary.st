printing
printNotPassingSummary
	self newLine; printBanner: 'Summary' color: SmalltalkCI ansiRed.
	runner results keysAndValuesDo: [ :class :results | | notPassing |
		notPassing := results select: [ :result | result passed not ].
		notPassing ifNotEmpty: [
			self printTitle: class asString.
			notPassing do: [ :result | self print: result ansiTitle; newLine ] ] ]