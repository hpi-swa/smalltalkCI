helpers
relativePathOf: aFilePath to: projectDirectory
	(aFilePath beginsWith: projectDirectory, '/')
		ifTrue: [ ^ aFilePath allButFirst: projectDirectory size + 1 ].
	^ aFilePath