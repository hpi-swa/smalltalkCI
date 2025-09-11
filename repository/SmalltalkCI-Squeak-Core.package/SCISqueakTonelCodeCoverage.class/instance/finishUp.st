setup
finishUp

	super finishUp.
	coveredMethodsByClassName := coveredMethods groupBy: [ :method | method actualClass name ]