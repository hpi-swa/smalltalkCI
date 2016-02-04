executing
basicLoadProjectOn: aSmalltalkCI
	aSmalltalkCI class requireMetacello.
	(Smalltalk at: #Metacello) new
		repository: (self loadRepositoryFor: aSmalltalkCI);
		baseline: self baseline;
		configuration: self configuration;
		load: self load