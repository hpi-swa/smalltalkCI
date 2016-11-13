helpers
classesToCover
	"This method needs to return an OrderedCollection. TestCoverage wrappers do not initialize correctly for some reason if this returns for example a Set"
	spec coverageEnabled
		ifTrue: [ ^ (SmalltalkCI classesFrom: spec coverageDictionary) asOrderedCollection ]
		ifFalse: [ ^ OrderedCollection new ]