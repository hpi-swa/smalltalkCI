coveralls
coverallsSourceFilesIn: projectDirectory
	^ (self isInTonelFormat: projectDirectory)
		ifTrue: [ self tonelCoverallsSourceFilesIn: projectDirectory ]
		ifFalse: [ super coverallsSourceFilesIn: projectDirectory ]
