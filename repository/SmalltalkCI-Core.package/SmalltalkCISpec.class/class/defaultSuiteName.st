defaults
defaultSuiteName
	| suiteName |
	suiteName := SmalltalkCI smalltalkSelection.
	SmalltalkCI isTravisBuild ifTrue: [
		^ suiteName, ' on TravisCI (', (SmalltalkCI getEnv: 'TRAVIS_JOB_NUMBER') asString, ')' ].
	SmalltalkCI isAppVeyorBuild ifTrue: [
		^ suiteName, ' on AppVeyor (', (SmalltalkCI getEnv: 'APPVEYOR_JOB_NAME') asString, ')' ].
	SmalltalkCI isGitLabCIBuild ifTrue: [ 
		^ suiteName, ' on GitLab CI (', (SmalltalkCI getEnv: 'CI_PIPELINE_ID') asString, '.', (SmalltalkCI getEnv: 'CI_JOB_ID') asString, ')' ].
	^ suiteName