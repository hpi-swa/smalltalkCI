executing
finishUpAfterCoverage
   | wrappersNotRun wrappersRun |
	wrappers do: [ :each | each uninstall ].
	wrappersRun := wrappers select: [ :each | each hasRun ].
	wrappersNotRun := wrappers reject: [ :each | each hasRun ].