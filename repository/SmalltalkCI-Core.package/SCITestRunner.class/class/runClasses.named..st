running
runClasses: aCollectionOfClasses named: aString
  | suite suiteName classes |
  suiteName := aString ifNil: [ self defaultSuiteName ].
  suite := TestSuite named: suiteName.
  classes := (aCollectionOfClasses
    select: [ :each | (each includesBehavior: TestCase) and: [ each isAbstract not ] ])
      asSortedCollection: [ :a :b | a name <= b name ].
  classes isEmpty
    ifTrue: [ ^ nil ].
  classes
    do: [ :each | each addToSuiteFromSelectors: suite ].
  ^ self runSuite: suite