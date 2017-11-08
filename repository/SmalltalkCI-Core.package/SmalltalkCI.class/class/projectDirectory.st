public-api
projectDirectory
	"ProjectDirectory := nil"
	^ ProjectDirectory ifNil: [ (SmalltalkCI getEnv: 'SCIII_PROJECT_DIR') asString ]