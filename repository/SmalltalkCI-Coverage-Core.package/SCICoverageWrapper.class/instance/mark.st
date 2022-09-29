private
mark
	hasRun := true.
	
	(SCICodeCoverage methodIsTraitMethod: method) ifTrue:
		["update original (shared) trait method"
		| original |
		original := (SCICodeCoverage eventualOriginalTraitMethodFor: method) methodReference compiledMethod.
		(original respondsTo: #mark) ifTrue:
			[original mark; uninstall]].