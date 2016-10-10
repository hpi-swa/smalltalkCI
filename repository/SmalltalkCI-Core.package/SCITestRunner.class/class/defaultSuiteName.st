helpers
defaultSuiteName
	| suiteName |
	suiteName := (SmalltalkCI getEnv: 'config_smalltalk') asString.
	SmalltalkCI isTravisBuild ifTrue: [
		suiteName := suiteName, ' on TravisCI (', (SmalltalkCI getEnv: 'TRAVIS_JOB_NUMBER') asString, ')' ].
	SmalltalkCI isAppVeyorBuild ifTrue: [
		suiteName := suiteName, ' on AppVeyor (', (SmalltalkCI getEnv: 'APPVEYOR_JOB_NAME') asString, ')' ].
	^ suiteName