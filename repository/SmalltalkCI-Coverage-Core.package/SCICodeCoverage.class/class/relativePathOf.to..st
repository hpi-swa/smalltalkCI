helpers
relativePathOf: aFilePath to: projectDirectory
	| normalizedUnixPath |
	normalizedUnixPath := aFilePath copyReplaceAll: '\' with: '/'.
	^ (normalizedUnixPath beginsWith: projectDirectory, '/')
		ifTrue: [ normalizedUnixPath allButFirst: projectDirectory size + 1 ]
		ifFalse: [ normalizedUnixPath ]