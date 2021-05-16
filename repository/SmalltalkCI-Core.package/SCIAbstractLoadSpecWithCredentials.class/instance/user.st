accessing
user

	user ifNotNil: [ ^ user ].
	self usernameEnvVar ifNotNil: [ :env | ^ SmalltalkCI getEnv: env ].
	^ nil