helpers
isAppVeyorBuild
	^ BuildEnvironment asString beginsWith: 'appveyor'