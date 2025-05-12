tests
testResourcesSetupOnce
	"This test ensures that SmalltalkCI only instantiates test resources once.
	In Pharo, some test runners nest suites and currently test resources are not
	properly handled in that case, i.e., test resources would be instantiated
	once per test class (usually)."
	self assert: SCIDummyPharoTestResource setUpCounter isNil.
	self assert: SCIDummyPharoTestResource tearDownCounter isNil.

	SmalltalkCI testRunnerClass runSpec: (SCIDummySpec forClasses: { 
		SCIPharoTestSuiteNestingTestCase1.
		SCIPharoTestSuiteNestingTestCase2 }).
		
	self assert: SCIDummyPharoTestResource setUpCounter equals: 1.
	self assert: SCIDummyPharoTestResource tearDownCounter equals: 1