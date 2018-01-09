executing
basicLoad
	"Force loading of packages during merge warnings"
	self disableIcebergDuring: [		
		[ super basicLoad ]
			on: (Smalltalk at: #MCMergeOrLoadWarning)
			do: [ :ex | ex resume: true ] ]