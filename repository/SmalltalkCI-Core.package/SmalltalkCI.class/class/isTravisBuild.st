helpers
isTravisBuild
	^ (self getEnv: 'TRAVIS') = 'true'