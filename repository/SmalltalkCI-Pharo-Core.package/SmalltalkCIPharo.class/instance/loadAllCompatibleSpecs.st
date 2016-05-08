executing
loadAllCompatibleSpecs
	"Force loading of packages during merge warnings"
	[ super loadAllCompatibleSpecs ]
		on: (Smalltalk at: #MCMergeOrLoadWarning)
		do: [ :ex | ex resume: true ]