helpers
exportBuildStatus: aBoolean
	"true if build was successful, false otherwise"
	| stream |
	stream := SmalltalkCI forceNewFileNamed: SmalltalkCI buildStatusFile.
	aBoolean
		ifTrue: [ stream nextPut: SmalltalkCI buildSuccessful ]
		ifFalse: [ stream nextPut: SmalltalkCI buildFailed ].
	stream close