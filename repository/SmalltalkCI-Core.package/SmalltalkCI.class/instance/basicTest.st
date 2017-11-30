executing
basicTest
	| runner |
	self ensureSpecIsValid.
	self class
		stage: 'Testing project...'
		id: 'test_project'
		block: [
			self prepareForTesting.
			self executionClass
				run: [ runner := self runTests ]
				spec: self spec
				in: self projectDirectory.
			self finishUpAfterTesting ].
	self reportResults: runner.
	runner isSuccessful
		ifFalse: [ SCIError signal: '[test failure]' ]