testing
testGitLabCIDetection
	(SmalltalkCI getEnv: 'GITLAB_CI') = 'true'
		ifTrue: [ self assert: SmalltalkCI isGitLabCIBuild ]
		ifFalse: [ self deny: SmalltalkCI isGitLabCIBuild ]