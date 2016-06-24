executing
load
	[ self prepareForLoading.
	"Install all specs for the current platform"
	self compatibleLoadSpecs 
		do: [ :each | each loadProjectOn: self ]
	] ensure: [ self finishUpAfterLoading ].
	SmalltalkCI printToStdout: 'Loading stage completed'