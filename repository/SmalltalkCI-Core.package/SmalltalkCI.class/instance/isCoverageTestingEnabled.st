accessing
isCoverageTestingEnabled
	^ SmalltalkCI platformSymbol ~= #gemstone
		and: [ (SmalltalkCI isTravisBuild
				or: [ SmalltalkCI isAppVeyorBuild or: [ SmalltalkCI isGitLabCIBuild ] ])
				and: [ self spec coverageEnabled ] ]