coverage
classesToCover
	self spec testing at: #coverage
		ifPresent: [ :co | ^ SmalltalkCI testClassesFrom: co]
		ifAbsent: [ ^ OrderedCollection new ]