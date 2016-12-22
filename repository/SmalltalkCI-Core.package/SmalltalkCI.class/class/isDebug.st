helpers
isDebug
	^ (self getEnv: 'SCIII_DEBUG') = 'true'