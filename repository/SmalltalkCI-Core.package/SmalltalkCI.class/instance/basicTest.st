executing
basicTest
	| runner coverage |
	self ensureSpecIsValid.
	self class
		stage: 'Testing project...'
		id: 'test_project'
		block: [
			self prepareForTesting.
			coverage := self executionClass
				run: [ runner := self runTests ]
				spec: self spec
				in: self projectDirectory.
			self finishUpAfterTesting ].
	coverage ifNotNil: [
		self class printToStdout: 'Exporting coverage...' ansiColor: self class ansiBlue, self class ansiBold.
		self executionClass exportCoverage: coverage in: self projectDirectory].
	self reportResults: runner.
	runner isSuccessful
		ifFalse: [ SCIError signal: '[test failure]' ]