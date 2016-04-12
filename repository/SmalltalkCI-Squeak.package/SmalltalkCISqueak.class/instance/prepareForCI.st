executing
prepareForCI
	| classesToBeCovered |
	self class isHeadless
		ifTrue: [ SCISqueakToolSet load ].
	SCISqueakTranscript install.

	classesToBeCovered := self classesForCategories: ((self spec testing at: #coverageAgainst) at: #categories).
	classesToBeCovered addAll: ((self spec testing at: #coverageAgainst) at: #classes).
	self prepareCoverageForClasses: classesToBeCovered.
	
	super prepareForCI