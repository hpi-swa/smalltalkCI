running
runSpec: aSCISpec named: aSuiteName
  | suite classes |
  suite := TestSuite named: (aSuiteName ifNil: [ self defaultSuiteName ]).
  classes := (aSCISpec classesToTest
    select: [ :each | (each includesBehavior: TestCase) and: [ each isAbstract not ] ])
      asSortedCollection: [ :a :b | a name <= b name ].
  classes
    do: [ :each | each addToSuiteFromSelectors: suite ].
  ^ self runSuite: suite spec: aSCISpec