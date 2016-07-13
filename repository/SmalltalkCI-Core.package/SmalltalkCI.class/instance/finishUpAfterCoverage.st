coverage
finishUpAfterCoverage
	| output |
	output := OrderedCollection new.

	coverageWrappers do: [ :wrapper | | directory |
		wrapper uninstall.
		directory := (self spec loading
			collect: [ :loadspec |
				self projectDirectory, SmalltalkCI pathNameDelimiter, loadspec directory ])
			detect: [ :dir |
				self class fileExists: (self fileNameFor: wrapper in: dir)]
			ifNone: [].
		directory ifNotNil: [
			output add: (self coverageDictFor: wrapper in: directory) ] ].
	
	self writeCoverageReport: output asArray