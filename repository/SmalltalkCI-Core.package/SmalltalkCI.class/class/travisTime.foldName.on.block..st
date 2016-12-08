folding
travisTime: aTitle foldName: foldName on: aStream block: aBlock
	| timerName start |
	timerName := foldName, '_timer_', self travisID.
	aStream
		nextPutAll: 'travis_time:start:', timerName, self newLine, self ansiClear;
		nextPutAll: (self foldTitle: aTitle); flush.
	start := Time millisecondClockValue * 1000000.
	aBlock ensure: [ | finish duration |
		finish := Time millisecondClockValue * 1000000.
		duration := finish - start.
		aStream nextPutAll: self newLine, 'travis_time:end:', timerName, ':start=', start asString,
			',finish=', finish asString, ',duration=', duration asString, self newLine, self ansiClear; flush ]