executing
test
	| runner |
	self headfullBreakpoint.

	SmalltalkCI stage: 'Testing project...' id: 'test_project' block: [
		self prepareForTesting.
		self isCoverageTestingEnabled
			ifTrue: [ SmalltalkCI codeCoverageClass
						run: [ runner := self runTests ]
						cover: self classesToCover
						spec: self spec
						in: self projectDirectory ]
			ifFalse: [ runner := self runTests ] ].

	self reportResults: runner.
	self finishUpAfterTesting: runner isSuccessful