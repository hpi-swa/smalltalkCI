executing
basicTest
	self ensureSpecIsValid.
	self class
		stage: 'Testing project...'
		id: 'test_project'
		block: [
			self prepareForTesting.
			self executionClass
				run: [ result := self runTests ]
				spec: self spec
				in: self projectDirectory.
			self finishUpAfterTesting ].
	self reportResults: result.
	result successful ifFalse: [ SCIError signal: '[test failure]' ]