tests
testAuthorIsEmptyFromPharo13

	SmalltalkCI platformClass = SmalltalkCIPharo13
		ifTrue: [ self assertEmpty: SmalltalkCI platformClass getAuthor ]
