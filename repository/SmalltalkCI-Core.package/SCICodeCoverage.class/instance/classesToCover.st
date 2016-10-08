helpers
classesToCover
	"This method needs to return an OrderedCollection. TestCoverage wrappers do not initialize correctly for some reason if this returns for example a Set"
	spec testing at: #coverage
		ifPresent: [ :co | ^ (SmalltalkCI classesFrom: co) asOrderedCollection ]
		ifAbsent: [ ^ OrderedCollection new ]