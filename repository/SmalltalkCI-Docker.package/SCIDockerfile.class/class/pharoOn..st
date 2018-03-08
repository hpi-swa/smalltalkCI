instance creation
pharoOn: aPlatform
	
	| toolDependencies commands |
	toolDependencies := #('ca-certificates' curl unzip wget git).
	commands := OrderedCollection new
		add: (SCIDockerComment contents: 'Pharo (32-bit)');
		add: (SCIDockerFROM new baseImage: 'ubuntu:16.04');
		addAll: (aPlatform sciDockerDependencyCommandsGivenTools: toolDependencies);
		yourself.
	^ self new
			instructions: commands;
			yourself.