coverage
classesToCover
	self spec testing at: #coverage
		ifPresent: [ :co | ^ SmalltalkCI classesToTestFrom: co]
		ifAbsent: [ ^ OrderedCollection new ]