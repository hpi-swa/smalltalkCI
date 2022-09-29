private
mark
	hasRun := true.
	
	(SCICodeCoverage methodIsTraitMethod: method) ifTrue:
		["update original (shared) trait method"
		(SCICodeCoverage eventualOriginalTraitMethodFor: method) ifNotNil: [:original |
			| installedOriginal |
			installedOriginal := original methodReference compiledMethod.
			(installedOriginal respondsTo: #mark) ifTrue:
				[installedOriginal mark; uninstall]]].