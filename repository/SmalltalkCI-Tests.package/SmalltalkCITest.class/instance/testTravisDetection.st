testing
testTravisDetection
	((SmalltalkCI getEnv: 'HAS_JOSH_K_SEAL_OF_APPROVAL') isNil and: [
				(SmalltalkCI platformClass imagePath findString: '/home/travis/') = 1 ])
		ifTrue: [ self assert: SmalltalkCI isTravisBuild ]
		ifFalse: [ self deny: SmalltalkCI isTravisBuild ].

	SmalltalkCI isTravisBuild ifTrue: [
		self
			assert: 'true'
			equals: (SmalltalkCI getEnv: 'CI').
		self
			assert: (SmalltalkCI getEnv: 'TRAVIS_SMALLTALK_VERSION') notEmpty
	]