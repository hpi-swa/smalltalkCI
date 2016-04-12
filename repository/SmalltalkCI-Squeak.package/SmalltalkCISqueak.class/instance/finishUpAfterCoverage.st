executing
finishUpAfterCoverage
	| output fileDirectory wrappersNotRun wrappersRun |
	wrappers do: [:each | each uninstall].
	wrappersRun := wrappers select: [:each | each hasRun].
	wrappersNotRun := wrappers reject: [:each | each hasRun].
	output := OrderedCollection new.
	fileDirectory := FileDirectory new.
	wrappers
		do: [:wrapper |
			self spec loading
				detect: [ :loadspec | 
					fileDirectory fileExists: self projectDirectory , FileDirectory slash , (self fileNameFor: wrapper in: loadspec directory)]
				ifFound: [ :loadspec |
					| fileName coverageSymbol dict |
					fileName := (self fileNameFor: wrapper in: loadspec directory).
					coverageSymbol := wrapper hasRun
						ifTrue: [ 1 ]
						ifFalse: [ 0 ].
					dict := Dictionary new.
					dict at: 'name' put: fileName.
					dict at: 'source_digest' put: (self md5ForFile: fileName).
					dict at: 'coverage' put: (Array new: (self linesOfFile: fileName) withAll: coverageSymbol).
					output add: dict ]
				ifNone: [ ] ].
	self halt.