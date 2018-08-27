modifying
add: aTestCaseResult for: aTestCase
	(results at: aTestCase class ifAbsentPut: [ OrderedCollection new ])
		add: aTestCaseResult