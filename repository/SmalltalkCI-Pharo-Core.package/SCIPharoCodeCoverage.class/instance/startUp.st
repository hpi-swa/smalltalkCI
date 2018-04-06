setup
startUp
	super startUp.
	includedMethodsByClassName := includedMethods groupedBy: [ :method | method actualClass name ]