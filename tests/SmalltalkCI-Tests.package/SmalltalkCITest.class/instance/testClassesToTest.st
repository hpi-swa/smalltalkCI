testing
testClassesToTest
	self spec addLoadSpec: (SCIMetacelloLoadSpec new
		baseline: 'SmalltalkCITests';
		platforms: { SmalltalkCI platformClass platformSymbol }).

	"Test packages prefixes (for pharo)"
	SmalltalkCI platformClass platformSymbol = #pharo
		ifTrue: [ ^ self classesToTestPackages ].
			
	"Test categories prefixes"
	self classesToTestCategories