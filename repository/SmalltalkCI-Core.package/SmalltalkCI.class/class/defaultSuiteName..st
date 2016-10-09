constants
defaultSuiteName: aFilenameString
	| suiteName |
	suiteName := (self getEnv: 'config_smalltalk') asString, ' with ', (aFilenameString copyAfterLast: $/).
	self isTravisBuild ifTrue: [
		suiteName := suiteName, ' on TravisCI (', (self getEnv: 'TRAVIS_JOB_NUMBER') asString, ')' ].
	self isAppVeyorBuild ifTrue: [
		suiteName := suiteName, ' on AppVeyor (', (self getEnv: 'APPVEYOR_JOB_NAME') asString, ')' ].
	^ suiteName