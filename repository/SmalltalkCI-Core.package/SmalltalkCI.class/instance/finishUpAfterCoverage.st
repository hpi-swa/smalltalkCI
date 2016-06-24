coverage
finishUpAfterCoverage
	| output |
	output := OrderedCollection new.

	coverageWrappers do: [ :wrapper | | loadSpec |
		wrapper uninstall.
		loadSpec := self spec loading
			detect: [ :loadspec | 
				self class fileExists: (self absoluteFileNameFor: wrapper in: loadspec directory)]
			ifNone: [].
		loadSpec ifNotNil: [
			output add: (self coverageDictFor: wrapper in: (loadSpec directory)) ] ].
	
	self writeCoverageReport: output asArray