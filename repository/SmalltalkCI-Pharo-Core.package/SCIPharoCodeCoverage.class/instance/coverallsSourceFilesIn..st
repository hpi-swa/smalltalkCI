coveralls
coverallsSourceFilesIn: projectDirectory
	^ (self isInTonelFormat: projectDirectory)
		ifTrue: [ self allClassesToCover
				collect: [ :classToCover | self tonelCoverallsSourceFileFor: classToCover in: projectDirectory ] ]
		ifFalse: [ super coverallsSourceFilesIn: projectDirectory ]