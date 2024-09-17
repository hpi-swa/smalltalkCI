testing
isAbstract
	"This test is run by another test and shouldn't be picked up by the runner"
	^ (thisContext findContextSuchThat: [ :ctx |
		ctx receiver class == SCIPharoTestSuiteNestingTest ]) isNil