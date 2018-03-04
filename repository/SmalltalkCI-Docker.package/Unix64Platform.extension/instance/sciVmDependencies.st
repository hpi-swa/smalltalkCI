*SmalltalkCI-Docker
sciVmDependencies
	^ super sciVmDependencies collect: [ :e | e, ':i386' ]