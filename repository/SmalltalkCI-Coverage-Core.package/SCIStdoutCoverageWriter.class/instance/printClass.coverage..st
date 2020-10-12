exporting
printClass: aClass coverage: anSCICodeCoverage

	self sci 
		printlnToStdout: (anSCICodeCoverage isFullyCovered ifTrue: [self class checkMark] ifFalse: [self class ballot]), ' ', aClass printString
		ansiColor: (anSCICodeCoverage isFullyCovered ifTrue: [self sci ansiGreen] ifFalse: [self sci ansiRed]), self sci ansiBold.
	
	anSCICodeCoverage uncoveredMethods do: [:methodReference |
		self sci printlnToStdout: '  ', self class ballot, ' ', methodReference selector asString ansiColor: self sci ansiRed].
	"We only need to print covered methods if there are any uncovered, otherwise the class is already marked as covered"
	anSCICodeCoverage isFullyCovered ifFalse: [ | numCovered |
		numCovered := anSCICodeCoverage uncoveredMethods size.
		self sci printlnToStdout: '  ', self class checkMark, ' ', numCovered asString, (' method' asPluralBasedOn: numCovered), ' covered' ansiColor: self sci ansiGreen].
	anSCICodeCoverage excludedMethods ifNotEmpty: [ :excluded |
		self sci printToStdout: '  ', self class info, ' ', excluded size asString, (' method' asPluralBasedOn: excluded), ' excluded from coverage'].
	"Add empty line between classes"
	self sci printToStdout: ''.