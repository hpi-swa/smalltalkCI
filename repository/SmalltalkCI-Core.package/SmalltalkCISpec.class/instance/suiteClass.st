accessing
suiteClass
	^ suiteClass ifNil: [ suiteClass := self testing at: #'suiteClass'
		ifPresent: [ :clazz |  (SmalltalkCI classesFrom: clazz) ]
		ifAbsent: [ TestSuite ] ]
