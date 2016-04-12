executing
finishUpAfterCoverage
	| output |
	output := OrderedCollection new.
	
	wrappers do: [:wrapper |
		wrapper uninstall.
		self spec loading
			detect: [ :loadspec | 
				FileDirectory default fileExists: (self absoluteFileNameFor: wrapper in: loadspec directory)]
			ifFound: [ :loadspec |
				output add: (self coverageDictFor: wrapper in: (loadspec directory))]
			ifNone: [ ] ].
	
	self writeCoverageReport: output asArray