helpers
assert: aFixture matches: aString
	"Assert that all characters of aFixture are also in aString (also respect the order)."
	| index |
	index := 1.
	aFixture do: [ :char | | newIndex |
		newIndex := aString indexOf: char startingAt: index.
		newIndex = 0 ifTrue: [
			TestResult failure signal: '$', char asString, ' not found startingAt ', index asString , '.' ].
		index := newIndex ]