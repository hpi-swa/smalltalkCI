setup
finishUp
	coverageWrappers do: [ :wrapper | wrapper uninstall ].
	coveredMethods := (coverageWrappers
		select: [ :each | each hasRun ])
		collect: [ :each | each reference ]