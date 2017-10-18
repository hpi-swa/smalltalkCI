accessing
isCoverageTestingEnabled
	^ SmalltalkCI platformSymbol ~= #gemstone
		and: [ (SmalltalkCI isTravisBuild
				or: [ SmalltalkCI isAppVeyorBuild or: [ SmalltalkCI isGitlabBuild ] ])
				and: [ self spec coverageEnabled ] ]