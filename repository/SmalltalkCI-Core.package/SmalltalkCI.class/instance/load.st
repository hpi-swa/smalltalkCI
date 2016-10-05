executing
load
	self headfullBreakpoint.
	
	SmalltalkCI travisFold: 'load_project' title: 'Loading project...' block: [ [
		self prepareForLoading.
		"Install all specs for the current platform"
		self compatibleLoadSpecs 
			do: [ :each | each loadProjectOn: self ]
		] ensure: [ self finishUpAfterLoading ] ].
	
	self saveImageAndQuit