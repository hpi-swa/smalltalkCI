executing
run: aBlock spec: aSmalltalkCISpec in: projectDirectory
	^ self new
		spec: aSmalltalkCISpec;
		run: aBlock;
		exportResultsIn: projectDirectory