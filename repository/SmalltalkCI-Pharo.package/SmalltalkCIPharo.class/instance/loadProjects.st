as yet unclassified
loadProjects
	"Force loading of packages during merge warnings"
	[ super loadProjects ]
		on: (Smalltalk at: #MCMergeOrLoadWarning)
		do: [ :ex | ex resume: true ]