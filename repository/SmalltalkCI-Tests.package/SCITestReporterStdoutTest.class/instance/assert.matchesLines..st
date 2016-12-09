helpers
assert: aFixture matchesLines: aString
	| fixtureLines stringLines |
	fixtureLines := aFixture lines.
	stringLines := aString lines.
	self assert: stringLines size equals: fixtureLines size.
	aFixture lines withIndexDo: [ :line :index |
		self assert: (line match: (stringLines at: index)) ]