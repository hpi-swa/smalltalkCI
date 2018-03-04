GT
saveTo: aFileReference
	| target |
	target := aFileReference isDirectory
		ifTrue: [ aFileReference / 'Dockerfile' ]
		ifFalse: [ aFileReference ].
	target writeStreamDo: [ :s | s print: self ]