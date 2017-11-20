finalizing
printStepsToReproduceLocally
	| smalltalkSelection |
	smalltalkSelection := self smalltalkSelection
		ifNotNil: [ :s | ' -s ', s ] ifNil: [ '' ].
	SmalltalkCI printWarningToStdout: 'To reproduce the failed build locally, download smalltalkCI, and try to run something like:

	bin/smalltalkci', smalltalkSelection ,' --headfull /path/to/.smalltalk.ston
'