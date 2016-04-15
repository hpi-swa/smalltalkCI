running
runCase: aTestCase
	| error stack  |
	self
		beginTestCase: aTestCase
		runBlock: [ [ [ aTestCase runCase ]
			on: Halt , Error, TestFailure
			do: [ :err |
				error := err.
				aTestCase shouldPass ifTrue: [self serializeError: error of: aTestCase].
				stack := self stackTraceString: err of: aTestCase ]]
					on: (Smalltalk at: #TestSkip ifAbsent: []) do: [ :err | "nothing to do..." ] ].

	error notNil
		ifTrue: [
			aTestCase shouldPass	ifTrue: [
				(error isKindOf: TestFailure)
					ifTrue: [ self writeFailure: error stack: stack ]
					ifFalse: [ self writeError: error stack: stack ] ] ]
		ifFalse: [
			aTestCase shouldPass ifFalse: [ self writeUnexpectedPassFailure ] ].

	self endTestCaseWith: error