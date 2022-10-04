setup
finishUp
	coverageWrappers do: [ :wrapper | wrapper uninstall ].
	coveredMethods := (coverageWrappers
		select: [ :each | each hasRun
			and: [(self class methodIsTraitMethod: each) not "trait methods' wrappers update their original method wrapper automatically, see SCICoverageWrapper>>#mark"] ])
		collect: [ :each | each reference ]