coverage
classesToCover
	self spec testing at: #coverageAgainst
		ifPresent: [ :co | ^ SmalltalkCI classesToTestFrom: co]
		ifAbsent: [ ^ #() ]