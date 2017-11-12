running
runClasses: aCollectionOfClasses spec: aSCISpec
  | suite classes |
  suite := TestSuite named: aSCISpec name.
  classes := (aCollectionOfClasses
    select: [ :each | (each includesBehavior: TestCase) and: [ each isAbstract not ] ])
      asSortedCollection: [ :a :b | a name <= b name ].
  classes
    do: [ :each | each addToSuiteFromSelectors: suite ].
  ^ self runSuite: suite spec: aSCISpec