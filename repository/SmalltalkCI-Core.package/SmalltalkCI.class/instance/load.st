executing
load
	self headfullBreakpoint.
	
	SmalltalkCI stage: 'Loading project...' id: 'load_project' block: [ [
		self prepareForLoading.
		"Install all specs for the current platform"
		self compatibleLoadSpecs 
			do: [ :each | each loadProjectOn: self ]
		] ensure: [ self finishUpAfterLoading ] ]