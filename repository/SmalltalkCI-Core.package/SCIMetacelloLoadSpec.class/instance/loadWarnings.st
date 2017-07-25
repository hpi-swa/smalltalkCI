private
loadWarnings
	Smalltalk at: #OCSemanticWarning ifPresent: [ :semanticWarning |
		^ Warning, semanticWarning ].
	^ Warning