testing
testTravisDetection
	(SmalltalkCI platformClass imagePath findString: '/travis/') > 0
		ifTrue: [ self assert: SmalltalkCI isTravisBuild ]
		ifFalse: [ self deny: SmalltalkCI isTravisBuild ].
		
	SmalltalkCI isTravisBuild ifTrue: [
		self
			assert: 'true'
			equals: (SmalltalkCI getEnv: 'CI').
		self
			assert: (SmalltalkCI getEnv: 'TRAVIS_SMALLTALK_VERSION') notEmpty
	]