executing
loadProjectOn: aSmalltalkCI
	self isComplete
		ifFalse: [ self error: 'This spec cannot be loaded or is incomplete.' ].
	self isPlatformCompatible
		ifFalse: [ self error: 'This spec cannot be loaded on this platform' ].
	self basicLoadProjectOn: aSmalltalkCI