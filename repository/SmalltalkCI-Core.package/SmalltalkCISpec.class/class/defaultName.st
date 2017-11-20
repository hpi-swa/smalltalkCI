defaults
defaultName
	| result |
	result := SmalltalkCI smalltalkSelection ifNil: [ 'unknown' ].
	SmalltalkCI isTravisBuild ifTrue: [
		^ result, ' on Travis CI (', (SmalltalkCI getEnv: 'TRAVIS_JOB_NUMBER') asString, ')' ].
	SmalltalkCI isAppVeyorBuild ifTrue: [
		^ result, ' on AppVeyor (', (SmalltalkCI getEnv: 'APPVEYOR_JOB_NAME') asString, ')' ].
	SmalltalkCI isGitLabCIBuild ifTrue: [ 
		^ result, ' on GitLab CI (', (SmalltalkCI getEnv: 'CI_PIPELINE_ID') asString, '.', (SmalltalkCI getEnv: 'CI_JOB_ID') asString, ')' ].
	^ result