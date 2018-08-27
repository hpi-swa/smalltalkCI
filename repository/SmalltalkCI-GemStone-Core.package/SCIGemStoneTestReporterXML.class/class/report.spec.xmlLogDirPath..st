executing
report: aSCITestResult spec: aSCISpec xmlLogDirPath: xmlLogDirPath
	| cacheStream |
	cacheStream := AnsiWriteStream on: String new.
	[ self report: aSCITestResult spec: aSCISpec on: cacheStream.
	SmalltalkCI
		forceNewFileNamed: (self xmlFileNamed: aSCITestResult suiteName in: xmlLogDirPath)
		do: [ :stream | stream nextPutAll: cacheStream ]]
			ensure: [ cacheStream close ]