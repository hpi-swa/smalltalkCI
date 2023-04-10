setup
finishUp
	super finishUp.
	coveredMethodsByClassName := coveredMethods groupedBy: [ :method | method actualClass name ]