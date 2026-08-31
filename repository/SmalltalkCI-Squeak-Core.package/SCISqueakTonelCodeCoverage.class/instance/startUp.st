setup
startUp

	super startUp.
	includedMethodsByClassName := includedMethods groupBy: [ :method | method actualClass name ].