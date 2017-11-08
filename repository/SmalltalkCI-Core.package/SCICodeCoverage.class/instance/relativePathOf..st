helpers
relativePathOf: aFilePath
	(aFilePath beginsWith: projectDirectory, '/')
		ifTrue: [ ^ aFilePath allButFirst: projectDirectory size + 1 ].
	^ aFilePath
	