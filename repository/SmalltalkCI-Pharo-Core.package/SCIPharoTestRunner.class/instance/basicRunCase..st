running
basicRunCase: aTestCase
	(self class environment hasClassNamed: #CurrentExecutionEnvironment) 
		ifTrue: [ aTestCase runCaseManaged ]
		ifFalse: [ super basicRunCase: aTestCase ]