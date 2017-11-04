public-api
projectDirectory
	^ ProjectDirectory ifNil: [ (SmalltalkCI getEnv: 'SCIII_PROJECT_DIR') asString ]