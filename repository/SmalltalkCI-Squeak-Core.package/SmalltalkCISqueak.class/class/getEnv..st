compatibility
getEnv: aKey
	self isWindows
		ifTrue: [ ^ self getEnvWindows: aKey ]
		ifFalse: [ ^ self getEnvUnix: aKey ]