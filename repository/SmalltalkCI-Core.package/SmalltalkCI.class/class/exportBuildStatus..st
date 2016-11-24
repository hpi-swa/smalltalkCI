finalizing
exportBuildStatus: buildSuccessful
	| stream |
	stream := SmalltalkCI forceNewFileNamed: SmalltalkCI buildStatusFile.
	buildSuccessful
		ifTrue: [ stream nextPut: SmalltalkCI buildSuccessful ]
		ifFalse: [ stream nextPut: SmalltalkCI buildFailed ].
	stream close