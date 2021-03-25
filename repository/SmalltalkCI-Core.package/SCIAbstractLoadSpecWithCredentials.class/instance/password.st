accessing
password

	password ifNotNil: [ ^ password ].
	self passwordEnv ifNotNil: [ :env | ^ SmalltalkCI getEnv: env ].
	^ ''