finalizing
shutdownHeadful: buildSuccessful
	buildSuccessful
		ifTrue: [ self notify: 'Build successful.' ]
		ifFalse: [ self error: 'Build failed.' ]