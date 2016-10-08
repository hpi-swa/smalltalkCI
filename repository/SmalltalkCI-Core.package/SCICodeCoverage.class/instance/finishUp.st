initialize-release
finishUp
	| sourceFiles |
	sourceFiles := OrderedCollection new.

	coverageWrappers do: [ :wrapper | | directory |
		wrapper uninstall.
		directory := (spec loading
			collect: [ :loadspec |
				projectDirectory, SmalltalkCI pathNameDelimiter, loadspec directory ])
			detect: [ :dir |
				SmalltalkCI platformClass fileExists: (self fileNameFor: wrapper in: dir)]
			ifNone: [].
		directory ifNotNil: [
			sourceFiles add: (self coverageDictFor: wrapper in: directory) ] ].
	
	coverallsData at: 'source_files' put: sourceFiles asArray.
	self uploadResults