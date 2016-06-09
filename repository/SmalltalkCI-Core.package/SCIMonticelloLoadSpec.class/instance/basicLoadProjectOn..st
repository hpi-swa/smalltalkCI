executing
basicLoadProjectOn: aSmalltalkCI
	| repository |
	repository := self repository.
	self extractVersionsFromPackages: repository.
	self loadVersions: repository