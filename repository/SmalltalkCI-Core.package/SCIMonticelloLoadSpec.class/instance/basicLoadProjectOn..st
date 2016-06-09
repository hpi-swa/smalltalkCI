executing
basicLoadProjectOn: aSmalltalkCI
	| repository |
	self smalltalkCI: aSmalltalkCI.
	repository := self repository.
	self extractVersionsFromPackages: repository.
	self loadVersions: repository