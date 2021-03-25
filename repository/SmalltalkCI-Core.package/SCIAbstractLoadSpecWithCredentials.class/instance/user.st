accessing
user

	user ifNotNil: [ ^ user ].
	self userEnv ifNotNil: [ :env | ^ SmalltalkCI getEnv: env ].
	^ ''