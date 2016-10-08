accessing
isCoverageTestingEnabled
	^ (SmalltalkCI isTravisBuild or: [ SmalltalkCI isAppVeyorBuild ]) and:
		[ self spec testing includesKey: #coverage ]