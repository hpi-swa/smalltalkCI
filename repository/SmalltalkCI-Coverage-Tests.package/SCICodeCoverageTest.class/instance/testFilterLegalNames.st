tests
testFilterLegalNames

	| coverage targetNames |
	coverage := SmalltalkCI codeCoverageClass new.

	"Non-patterns are always legal"
	self
		assert: (coverage filterLegalNames: #( 'XYZ' 'ZYX' ))
		equals: #( 'XYZ' 'ZYX' ).

	"Even when they prefix an exclusion"
	targetNames := coverage class ignoredPackages
				withIndexCollect: [ :name :index |
					name allButLast: (1 + index min: name size // 3) ].
	self
		assert: (coverage filterLegalNames: targetNames)
		equals: targetNames.

	"Patterns which prefix an exclusion are ignored"
	self
		assert: (coverage filterLegalNames:
				 (targetNames collect: [ :name | name copyWith: $* ]))
		equals: #(  ).
	self
		assert: (coverage filterLegalNames:
				 (targetNames collect: [ :name | name , '.*' ]))
		equals: #(  )