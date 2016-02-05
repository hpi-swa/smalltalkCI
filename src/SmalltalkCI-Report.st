Object subclass: #SCIReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkCI-Report'!
!SCIReport commentStamp: 'TorstenBergmann 2/12/2014 22:30' prior: 0!
A Hudson report!


!SCIReport methodsFor: 'private' stamp: 'lr 5/15/2010 14:27'!
convert: aString
  ^ (aString asString
    copyReplaceAll: (String with: Character cr with: Character lf) with: (String with: Character lf))
    copyReplaceAll: (String with: Character cr) with: (String with: Character lf)! !

!SCIReport methodsFor: 'private' stamp: 'lr 5/14/2010 08:36'!
encode: aString
  ^ ((aString asString
    copyReplaceAll: '&' with: '&amp;')
    copyReplaceAll: '"' with: '&quot;')
    copyReplaceAll: '<' with: '&lt;'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SCIReport class
	instanceVariableNames: ''!

!SCIReport class methodsFor: 'running' stamp: 'fn 1/24/2016 14:11'!
runClasses: aCollectionOfClasses named: aString
	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SCIReport subclass: #SCITestReport
	instanceVariableNames: 'suite stream suitePosition suiteTime suiteFailures suiteErrors progressFile'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkCI-Report'!
!SCITestReport commentStamp: 'TorstenBergmann 2/12/2014 22:31' prior: 0!
Hudson report for test results!


!SCITestReport methodsFor: 'testing' stamp: 'EstebanLorenzano 8/21/2015 07:29'!
hasFailuresOrErrors
  ^ suiteFailures ~= 0 or: [ suiteErrors ~= 0 ]! !


!SCITestReport methodsFor: 'accessing' stamp: 'EstebanLorenzano 8/21/2015 07:43'!
suiteErrors
  ^ suiteErrors! !

!SCITestReport methodsFor: 'accessing' stamp: 'EstebanLorenzano 8/21/2015 07:42'!
suiteFailures
  ^ suiteFailures! !

!SCITestReport methodsFor: 'accessing' stamp: 'EstebanLorenzano 8/21/2015 07:48'!
suitePassing
  ^ self suiteTotal - self suiteFailures - self suiteErrors! !

!SCITestReport methodsFor: 'accessing' stamp: 'EstebanLorenzano 8/21/2015 08:02'!
suiteTotal
  ^ suite
    ifNotNil: [ suite tests size ]
    ifNil: [ 0 ]! !


!SCITestReport methodsFor: 'initialization' stamp: 'fn 1/12/2016 23:00'!
initialize
  super initialize.
  suiteTime := 0 asDuration.
  suitePosition := suiteFailures := suiteErrors := 0.
  progressFile := StandardFileStream stdout
  ! !

!SCITestReport methodsFor: 'initialization' stamp: 'EstebanLorenzano 8/26/2015 12:06'!
initializeOn: aTestSuite
  suite := aTestSuite! !


!SCITestReport methodsFor: 'private' stamp: 'fn 1/17/2016 02:57'!
beginTestCase: aTestCase runBlock: aBlock
  | time |
  progressFile
    nextPutAll: 'starting testcase: ' ;
    nextPutAll: aTestCase class name;
    nextPutAll:'>>';
    nextPutAll: aTestCase selector;
    nextPutAll: ' ... ';
    flush.

  time := self formatTime: (aBlock timeToRun).

  stream tab;
    nextPutAll: '<testcase classname="';
    nextPutAll: (self encode: (aTestCase class category copyReplaceAll: '-' with: '.'));
    nextPut: $.; nextPutAll: (self encode: aTestCase class name);
    nextPutAll: '" name="'; nextPutAll: (self encode: aTestCase selector);
    nextPutAll: '" time="'; print: time;
    nextPutAll: '">'; lf

! !

!SCITestReport methodsFor: 'private' stamp: 'CamilloBruni 11/4/2013 08:29'!
endTestCase
  stream tab; nextPutAll: '</testcase>'; lf.
  progressFile nextPutAll: 'finished' ; crlf; flush.
! !

!SCITestReport methodsFor: 'private' stamp: 'CamilloBruni 11/4/2013 08:27'!
stackTraceString: err of: aTestCase
  ^ String streamContents: [ :str |
    | context |
    context := err signalerContext.
    [ context isNil or: [ context receiver == aTestCase and: [ context methodSelector == #runCase ] ] ] whileFalse: [
      str print: context; lf.
      context := context sender ] ] ! !

!SCITestReport methodsFor: 'private' stamp: 'CamilloBruni 11/4/2013 08:27'!
writeError: error stack: stack
  suiteErrors := suiteErrors + 1.
  stream tab; tab; nextPutAll: '<error type="'.
  self writeException: error stack: stack.
  stream nextPutAll: '</error>'; lf! !

!SCITestReport methodsFor: 'private' stamp: 'CamilloBruni 7/20/2012 16:53'!
writeException: error stack: stack.

  stream
    nextPutAll: (self encode: error class name);
    nextPutAll: '" message="'; nextPutAll: (self encode: (error messageText ifNil: [ error description ]));
    nextPutAll: '">';
    nextPutAll: (self encode: stack).! !

!SCITestReport methodsFor: 'private' stamp: 'CamilloBruni 11/4/2013 08:27'!
writeFailure: error stack: stack
  suiteFailures := suiteFailures + 1.
  stream tab; tab; nextPutAll: '<failure type="'.
  self writeException: error stack: stack.
  stream  nextPutAll: '</failure>'; lf! !

!SCITestReport methodsFor: 'private' stamp: 'fn 1/23/2016 19:34'!
writeUnexpectedPassFailure
  suiteFailures := suiteFailures + 1.
  stream tab; tab;
	nextPutAll: '<failure type="UnexpectedTestPass" message="Test passed unexpectedly."></failure>'; lf! !


!SCITestReport methodsFor: 'running' stamp: 'fn 1/23/2016 19:40'!
run
	[ self setUp. suiteTime := [ self runAll ] timeToRun ] ensure: [ self tearDown ]! !

!SCITestReport methodsFor: 'running' stamp: 'fniep 1/12/2016 22:15'!
runAll
  suite tests do: [ :each | each run: self ]! !

!SCITestReport methodsFor: 'running' stamp: 'fn 1/23/2016 19:53'!
runCase: aTestCase
  | error stack  |
  self
    beginTestCase: aTestCase
    runBlock: [ [ [ aTestCase runCase ]
      on: Halt , Error, TestFailure
      do: [ :err |
        error := err.
        aTestCase shouldPass ifTrue: [self serializeError: error of: aTestCase].
        stack := self stackTraceString: err of: aTestCase ]]
      on: (Smalltalk at: #TestSkip ifAbsent: []) do: [ :err | "nothing to do..." ] ].

  (error notNil or: [aTestCase shouldPass not])  ifTrue: [
    (error isKindOf: TestFailure)
      ifTrue: [ self writeFailure: error stack: stack ]
      ifFalse: [
		aTestCase shouldPass
			ifTrue: [ self writeError: error stack: stack ]
			ifFalse: [ error isNil ifTrue: [self writeUnexpectedPassFailure ]]]].

  self endTestCase! !

!SCITestReport methodsFor: 'running' stamp: 'fn 1/23/2016 19:39'!
serializeError: error of: aTestCase
  "We got an error from a test, let's serialize it so we can properly debug it later on..."
  | context testCaseMethodContext |

  context := error signalerContext.
  testCaseMethodContext := context findContextSuchThat: [ :ctx|
    ctx receiver == aTestCase and: [ ctx methodSelector == #performTest ]].
  context := context copyTo: testCaseMethodContext.

  [ Smalltalk at: #FuelOutStackDebugAction ifPresent: [ :fosda |
    fosda serializeTestFailureContext: context sender
    toFileNamed: aTestCase class name asString,'-', aTestCase selector, '.fuel' ]]
  on: Error
  do: [:err| "simply continue..." ]

! !

!SCITestReport methodsFor: 'running' stamp: 'DamienCassou 2/20/2014 16:54'!
setUp
  progressFile nextPutAll: 'running suite: ';
    nextPutAll: suite name ; crlf; flush.

  stream := StandardFileStream forceNewFileNamed: suite name , '.xml'.
  stream := MultiByteFileStream newFrom: stream.
  stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'; lf.
  stream nextPutAll: '<testsuite name="'; nextPutAll: (self encode: suite name);
    nextPutAll: '" tests="'; print: suite tests size; nextPutAll: '">'.

  "Now this is ugly. We want to update the time and the number of failures and errors, but still at the same time stream a valid XML. So remember this position and add some whitespace, that we can fill later."
  suitePosition := stream position - 1.
  stream nextPutAll: (String new: 100 withAll: $ ); lf.

  "Initialize the test resources."
  suite resources do: [ :each |
    each isAvailable
      ifFalse: [ each signalInitializationError ] ]! !

!SCITestReport methodsFor: 'running' stamp: 'fn 1/17/2016 02:57'!
tearDown
  suite resources
    do: [ :each | each reset ].

  stream tab; nextPutAll: '<system-out><!![CDATA[]]></system-out>'; lf.
  stream tab; nextPutAll: '<system-err><!![CDATA[]]></system-err>'; lf.
  stream nextPutAll: '</testsuite>'.

  stream position: suitePosition.
  stream
    nextPutAll: ' failures="'; print: suiteFailures;
    nextPutAll: '" errors="'; print: suiteErrors;
    nextPutAll: '" time="'; print: (self formatTime: suiteTime);
    nextPutAll: '">'.
  stream close.

  progressFile
    nextPutAll: 'finished running suite: ';
    nextPutAll: suite name! !


!SCITestReport methodsFor: 'compatibility' stamp: 'fn 1/17/2016 02:57'!
formatTime: aTime
	| time |
	time := aTime.
	(aTime respondsTo: #asMilliSeconds)
    		ifTrue: [ time := aTime asMilliSeconds ].
	^ time / 1000.0
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SCITestReport class
	instanceVariableNames: ''!

!SCITestReport class methodsFor: 'running' stamp: 'EstebanLorenzano 8/25/2015 16:00'!
runClasses: aCollectionOfClasses named: aString
  | suite classes |
  suite := TestSuite named: aString.
  classes := (aCollectionOfClasses
    select: [ :each | (each includesBehavior: TestCase) and: [ each isAbstract not ] ])
      asSortedCollection: [ :a :b | a name <= b name ].
  classes isEmpty
    ifTrue: [ ^ nil ].
  classes
    do: [ :each | each addToSuiteFromSelectors: suite ].
  ^ self runSuite: suite! !

!SCITestReport class methodsFor: 'running' stamp: 'fn 1/16/2016 16:55'!
runSuite: aTestSuite
  ^ self new
    initializeOn: aTestSuite;
    run! !

