coverage
finishUpAfterCoverage
	| output |
	output := OrderedCollection new.
	
	coverageWrappers do: [:wrapper |
		wrapper uninstall.
		self spec loading
			detect: [ :loadspec | 
				(self absoluteFileNameFor: wrapper in: loadspec directory) asFileReference exists ]
			ifFound: [ :loadspec |
				output add: (self coverageDictFor: wrapper in: (loadspec directory))]
			ifNone: [ ] ].
	
	self writeCoverageReport: output asArray