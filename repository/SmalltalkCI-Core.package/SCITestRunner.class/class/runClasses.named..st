running
runClasses: aCollectionOfClasses named: aString
  | suite name classes |
  name := aString ifNil: [ self defaultSuiteName ].
  suite := TestSuite named: name.
  classes := (aCollectionOfClasses
    select: [ :each | (each includesBehavior: TestCase) and: [ each isAbstract not ] ])
      asSortedCollection: [ :a :b | a name <= b name ].
  classes isEmpty
    ifTrue: [ ^ nil ].
  classes
    do: [ :each | each addToSuiteFromSelectors: suite ].
  ^ self runSuite: suite