folding
travisTime: aTitle foldName: foldName on: aStream block: aBlock
	| start finish |
	aStream
		nextPutAll: 'travis_time:start:', foldName, '_timer', self newLine, self ansiClear;
		nextPutAll: (self foldTitle: aTitle).
	[
		start := Time millisecondClockValue * 1000000.
		aBlock value.
		finish := Time millisecondClockValue * 1000000
	] ensure: [ | duration |
		duration := finish - start.
		aStream nextPutAll: self newLine, 'travis_time:end:', foldName, '_timer:start=', start asString,
			',finish=', finish asString, ',duration=', duration asString, self newLine, self ansiClear ]