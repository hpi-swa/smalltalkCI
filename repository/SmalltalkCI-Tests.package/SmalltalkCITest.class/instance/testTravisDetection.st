testing
testTravisDetection
	(self imagePath findString: '/travis/') > 0
		ifTrue: [ self assert: SmalltalkCI isTravisBuild ]
		ifFalse: [ self deny: SmalltalkCI isTravisBuild ]