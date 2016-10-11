helpers
isAppVeyorBuild
	^ (self getEnv: 'APPVEYOR') = 'True'