*SmalltalkCI-Docker
sciDockerDependencyCommandsGivenTools: aCollection 
	| dependencies |
	dependencies := self sciVmDependencies, aCollection.
	^ {
			SCIDockerRUN install: dependencies sort.
			SCIDockerRUN command: 'echo "Pharo 32-bit prerequisities installed."' }