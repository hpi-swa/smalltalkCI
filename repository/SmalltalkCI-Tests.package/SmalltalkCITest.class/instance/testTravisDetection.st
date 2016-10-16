testing
testTravisDetection
	(SmalltalkCI platformClass imagePath findString: '/travis/') > 0
		ifTrue: [ self assert: SmalltalkCI isTravisBuild ]
		ifFalse: [ self deny: SmalltalkCI isTravisBuild ].
		
	SmalltalkCI isTravisBuild ifTrue: [
		self
			assert: 'true'
			equals: (SmalltalkCI getEnv: 'CI')
			description: '$CI not set to true'.
		self
			assert: (SmalltalkCI getEnv: 'TRAVIS_SMALLTALK_VERSION') notEmpty
			description: '$TRAVIS_SMALLTALK_VERSION is empty'
	]