executing
prepareCoverageForClasses: anOrderedCollection
	| methods |
	methods := anOrderedCollection collect: [ :classSelector |
		(Smalltalk at: classSelector) organization allMethodSelectors collect: [ :methodSelector |
			 MethodReference class: (Smalltalk at: classSelector) selector: methodSelector ] ].
	methods := methods flatten.
	wrappers := methods collect: [ :each | TestCoverage on: each ].
	wrappers do: [ :each | each install ].