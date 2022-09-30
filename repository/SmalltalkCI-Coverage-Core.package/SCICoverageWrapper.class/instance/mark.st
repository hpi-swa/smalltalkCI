private
mark
	hasRun := true.
	
	(CodeCoverageClass methodIsTraitMethod: method) ifTrue:
		["update original (shared) trait method"
		(CodeCoverageClass eventualOriginalTraitMethodFor: method) ifNotNil: [:original |
			| installedOriginal |
			installedOriginal := original methodReference compiledMethod.
			(installedOriginal respondsTo: #mark) ifTrue:
				[installedOriginal mark; uninstall]]].