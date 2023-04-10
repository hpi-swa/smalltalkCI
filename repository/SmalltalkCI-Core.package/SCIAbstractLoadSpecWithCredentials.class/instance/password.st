accessing
password

	password ifNotNil: [ ^ password ].
	self passwordEnvVar ifNotNil: [ :env | ^ SmalltalkCI getEnv: env ].
	^ nil