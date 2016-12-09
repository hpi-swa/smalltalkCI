helpers
assert: aFixture matches: aString
	"Assert that all characters of aFixture are also in aString (also respect the order)."
	| index |
	index := 1.
	aFixture do: [ :char | 
		index := aString indexOf: char startingAt: index.
		index = 0 ifTrue: [
			TestResult failure signal: 'Cannot match: "', aFixture, '" to: "', aString , '"' ] ]