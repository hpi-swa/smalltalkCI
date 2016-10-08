accessing
isCoverageTestingEnabled
	^ SmalltalkCI platformSymbol ~= #gemstone and:
		[ (SmalltalkCI isTravisBuild or: [ SmalltalkCI isAppVeyorBuild ]) and:
			[ self spec testing includesKey: #coverage ] ]