running
runClasses: aCollectionOfClasses spec: aSCISpec

	| suite classes resources |
	suite := TestSuite named: aSCISpec name.
	classes := (aCollectionOfClasses select: [ :each |
		            (each includesBehavior: TestCase) and: [
			            each isAbstract not ] ]) asSortedCollection: [ :a :b |
		           a name <= b name ].

	resources := OrderedCollection new.
	classes do: [ :class |
		| classSuite |
		classSuite := class suite.
		resources addAll: (classSuite resources reject: [ :resource |
				 resources includes: resource ]).
		"Reset resources of nested suit. Resources are managed by the outermost suite."
		classSuite resources: #(  ).
		suite addTest: classSuite ].

	suite resources: resources.

	^ self runSuite: suite spec: aSCISpec