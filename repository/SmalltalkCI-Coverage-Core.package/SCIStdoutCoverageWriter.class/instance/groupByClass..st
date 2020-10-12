exporting
groupByClass: anSCICodeCoverage

	| classCoverage |
	classCoverage := Dictionary new.
	self addMethods: anSCICodeCoverage includedMethods to: classCoverage atKey: #included.
	self addMethods: anSCICodeCoverage excludedMethods to: classCoverage atKey: #excluded.
	self addMethods: anSCICodeCoverage coveredMethods to: classCoverage atKey: #covered.
	^ classCoverage