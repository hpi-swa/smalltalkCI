executing
report: aSCITestRunner spec: aSCISpec xmlLogDirPath: xmlLogDirPath
	| cacheStream |
	cacheStream := AnsiWriteStream on: String new.
	[ self report: aSCITestRunner spec: aSCISpec on: cacheStream.
	SmalltalkCI
		forceNewFileNamed: (self xmlFileNamed: aSCITestRunner suiteName in: xmlLogDirPath)
		do: [ :stream | stream nextPutAll: cacheStream ]]
			ensure: [ cacheStream close ]