coverage
classesToCover
	self spec testing at: #coverage
		ifPresent: [ :co | ^ SmalltalkCI classesFrom: co]
		ifAbsent: [ ^ OrderedCollection new ]