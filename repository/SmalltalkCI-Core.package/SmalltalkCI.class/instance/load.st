executing
load
	| time |
	SmalltalkCI startTravisFold: 'load_project' title: 'Loading project...'.

	SmalltalkCI platformClass isHeadless ifFalse: [ self halt ].
	
	time := SmalltalkCI timeToRun: [[
		self prepareForLoading.
		"Install all specs for the current platform"
		self compatibleLoadSpecs 
			do: [ :each | each loadProjectOn: self ]
	] ensure: [ self finishUpAfterLoading ]].

	SmalltalkCI endTravisFold: 'load_project' message: 'Loading stage completed' time: time