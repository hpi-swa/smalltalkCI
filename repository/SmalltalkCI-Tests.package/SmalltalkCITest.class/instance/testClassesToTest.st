testing
testClassesToTest
	self spec addLoadSpec: (SCIMetacelloLoadSpec new
		baseline: 'SmalltalkCITests';
		platforms: { SmalltalkCI platformSymbol }).

	"Test categories prefixes"
	self classesToTestCategories.
	
	"Test packages prefixes (for pharo)"
	SmalltalkCI platformSymbol = #pharo
		ifTrue: [ self classesToTestPackages ]