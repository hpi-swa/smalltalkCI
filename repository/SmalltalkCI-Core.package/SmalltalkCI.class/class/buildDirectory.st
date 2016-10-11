constants
buildDirectory
	^ (self getEnv: 'SMALLTALK_CI_BUILD') ifNil: [ '' ]