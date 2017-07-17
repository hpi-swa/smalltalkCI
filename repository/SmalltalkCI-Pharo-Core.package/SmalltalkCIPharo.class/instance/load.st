executing
load
	"Force loading of packages during merge warnings"
	self disableIcebergDuring: [		
		[ super load ]
			on: (Smalltalk at: #MCMergeOrLoadWarning)
			do: [ :ex | ex resume: true ] ]