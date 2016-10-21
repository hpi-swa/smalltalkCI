finalizing
printStepsToReproduceLocally
	SmalltalkCI printToStdout: 'To reproduce the failed build locally, download smalltalkCI and try to run something like:

  /path/to/run.sh -s ', self smalltalkSelection ,' --headful /path/to/project/.smalltalk.ston
'