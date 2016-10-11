constants
buildDirectory
	^ (self getEnv: 'SCIII_BUILD') ifNil: [ '' ]