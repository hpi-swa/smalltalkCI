testing
testAppVeyorDetection
	(SmalltalkCI getEnv: 'USER') = 'appveyor'
		ifTrue: [ self assert: SmalltalkCI isAppVeyorBuild ]
		ifFalse: [ self deny: SmalltalkCI isAppVeyorBuild ].

	SmalltalkCI isAppVeyorBuild ifTrue: [
		self
			assert: 'True'
			equals: (SmalltalkCI getEnv: 'CI').
		self
			assert: (SmalltalkCI getEnv: 'APPVEYOR_PROJECT_NAME') notEmpty
	]