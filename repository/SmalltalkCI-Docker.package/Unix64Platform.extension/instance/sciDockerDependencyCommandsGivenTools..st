*SmalltalkCI-Docker
sciDockerDependencyCommandsGivenTools: aCollection 
	^ OrderedCollection new
			add: SCIDockerRUN enable32BitArchitecture;
			addAll: (super sciDockerDependencyCommandsGivenTools: aCollection);
			yourself