running
runAll
	"environment logic to be compatible with old pharos < 6"
	| currentEnvironment |
	(self class environment hasClassNamed: #CurrentExecutionEnvironment) ifFalse: [
		^ super runAll ].
	
	currentEnvironment := self class environment classNamed: #CurrentExecutionEnvironment.
	currentEnvironment runTestsBy: [
		suite run: self 
	]
