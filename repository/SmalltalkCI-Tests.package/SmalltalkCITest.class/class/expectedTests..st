helpers
expectedTests: aClass
	^ (SmalltalkCI methodDictOf: aClass) keys select: [ :ea | ea beginsWith: 'test' ]