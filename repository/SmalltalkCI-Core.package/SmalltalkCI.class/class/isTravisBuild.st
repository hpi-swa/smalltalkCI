helpers
isTravisBuild
	^ BuildEnvironment asString beginsWith: 'travis'