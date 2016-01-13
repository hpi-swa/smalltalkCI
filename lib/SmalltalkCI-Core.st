Object subclass: #SCIAbstractLoadSpec	instanceVariableNames: 'projectDirectory'	classVariableNames: ''	poolDictionaries: ''	category: 'SmalltalkCI-Core'!!SCIAbstractLoadSpec methodsFor: 'installing' stamp: 'fn 1/10/2016 11:53'!dependenciesInstalled	^ self subclassReponsibility! !!SCIAbstractLoadSpec methodsFor: 'installing' stamp: 'fn 1/10/2016 11:52'!installDependencies	^ self subclassReponsibility! !!SCIAbstractLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/10/2016 23:47'!isComplete	^ false! !!SCIAbstractLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 23:34'!isPlatformCompatible	^ self platforms includes: SmalltalkCISpec platformSymbol! !!SCIAbstractLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 02:41'!platforms	^ self subclassResponsibility! !!SCIAbstractLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 02:55'!platforms: aPlatform	^ self subclassResponsibility! !!SCIAbstractLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/10/2016 17:32'!projectDirectory	^ projectDirectory! !!SCIAbstractLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/10/2016 17:32'!projectDirectory: aDirectory	projectDirectory := aDirectory! !!SCIAbstractLoadSpec methodsFor: 'exporting' stamp: 'fniep 1/10/2016 16:59'!exportSTON	^ STON toStringPretty: self! !!SCIAbstractLoadSpec methodsFor: 'exporting' stamp: 'fniep 1/10/2016 17:15'!exportSTONFile: aFilenameString	| stream |	stream := StandardFileStream forceNewFileNamed: aFilenameString.  	stream := MultiByteFileStream newFrom: stream.	stream nextPutAll: self exportSTON.	stream close	! !!SCIAbstractLoadSpec methodsFor: 'loading' stamp: 'fniep 1/10/2016 23:47'!execute	self isComplete ifFalse: [ self error: 'This spec cannot be loaded or is incomplete.' ]! !!SCIAbstractLoadSpec methodsFor: 'loading' stamp: 'fniep 1/11/2016 02:46'!loadProject: aDirectory	self projectDirectory: aDirectory.	self isComplete		ifFalse: [ self error: 'This spec cannot be loaded or is incomplete.' ].	self isPlatformCompatible		ifFalse: [ self error: 'This spec cannot be loaded on this platform' ].	self dependenciesInstalled		ifFalse: [ self installDependencies ].	self dependenciesInstalled		ifFalse: [ self error: 'Dependencies could not be installed.' ].	self execute! !SCIAbstractLoadSpec subclass: #SCIMetacelloLoadSpec	instanceVariableNames: 'baseline configuration directory load platforms repository'	classVariableNames: ''	poolDictionaries: ''	category: 'SmalltalkCI-Core'!!SCIMetacelloLoadSpec methodsFor: 'installing' stamp: 'fniep 1/10/2016 18:20'!dependenciesInstalled	(Smalltalk includesKey: #Metacello)		ifFalse: [ ^ false ].			((self determineRepository beginsWith: 'filetree://') or:			[ (self determineRepository beginsWith: 'github//') ])		ifTrue: [ self filetreeInstalled ifFalse: [ ^ false ] ].	^ true! !!SCIMetacelloLoadSpec methodsFor: 'installing' stamp: 'fniep 1/10/2016 12:37'!filetreeInstalled	| organizer |	Smalltalk at: #PackageOrganizer ifPresent: [ :o | organizer := o ].	Smalltalk at: #RPackageOrganizer ifPresent: [ :o | organizer := o ].	organizer ifNil: [ self error: 'Unable to search for FileTree packages' ].	organizer default packageNamed: 'Metacello-FileTree' ifAbsent: [ ^ false ].	^ true! !!SCIMetacelloLoadSpec methodsFor: 'installing' stamp: 'fniep 1/11/2016 23:34'!installDependencies	(SmalltalkCISpec platformSymbol = #squeak)		ifTrue: [ self installMetacelloOnSqueak ].	(SmalltalkCISpec platformSymbol = #pharo)		ifTrue: [ self installMetacelloOnPharo ].	(SmalltalkCISpec platformSymbol = #gemstone)		ifTrue: [ self installMetacelloOnGemStone ]! !!SCIMetacelloLoadSpec methodsFor: 'installing' stamp: 'fn 1/10/2016 11:52'!installMetacelloOnGemStone  (Smalltalk at: #Gofer) new    package: 'GsUpgrader-Core';    url: 'http://ss3.gemtalksystems.com/ss/gsUpgrader';    load.  (Smalltalk at: #GsUpgrader) upgradeMetacello.! !!SCIMetacelloLoadSpec methodsFor: 'installing' stamp: 'fn 1/10/2016 11:52'!installMetacelloOnPharo  (Smalltalk at: #Metacello) new    baseline: 'Metacello';    repository: 'github://dalehenrich/metacello-work:master/repository';    get.  (Smalltalk at: #Metacello) new    baseline: 'Metacello';    repository: 'github://dalehenrich/metacello-work:master/repository';    onConflict: [:ex | ex allow];    load! !!SCIMetacelloLoadSpec methodsFor: 'installing' stamp: 'fniep 1/10/2016 18:28'!installMetacelloOnSqueak  "Get the Metacello configuration (for Squeak users)"  Installer gemsource      project: 'metacello';      addPackage: 'ConfigurationOfMetacello';      install.  "Bootstrap Metacello Preview, using mcz files (#'previewBootstrap' symbolic version"  ((Smalltalk at: #ConfigurationOfMetacello) project     version: #'previewBootstrap') load.  "Load the Preview version of Metacello from GitHub"  (Smalltalk at: #Metacello) new    configuration: 'MetacelloPreview';    version: #stable;    repository: 'github://dalehenrich/metacello-work:configuration';    load.  "Now load latest version of Metacello"  (Smalltalk at: #Metacello) new    baseline: 'Metacello';    repository: 'github://dalehenrich/metacello-work:master/repository';    get.  (Smalltalk at: #Metacello) new    baseline: 'Metacello';    repository: 'github://dalehenrich/metacello-work:master/repository';    load! !!SCIMetacelloLoadSpec methodsFor: 'loading' stamp: 'fniep 1/10/2016 18:19'!determineRepository	self repository		ifNil: [ ^ 'filetree://', self projectDirectory, '/', self directory ].	^ self repository! !!SCIMetacelloLoadSpec methodsFor: 'loading' stamp: 'fniep 1/11/2016 00:41'!execute	(Smalltalk at: #Metacello) new		repository: self determineRepository;		baseline: self baseline;		configuration: self configuration;		load: self load.! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:44'!baseline	^ baseline! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:44'!baseline: aBaseline	baseline := aBaseline! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:45'!configuration	^ configuration! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:44'!configuration: aConfiguration	configuration := aConfiguration! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/10/2016 17:54'!directory	^ directory! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/10/2016 17:54'!directory: aDirectory	directory := aDirectory! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 02:41'!isComplete	self platforms isEmpty		ifTrue: [ ^ false ].	(self baseline isNil and: [ self configuration isNil ])		ifTrue: [ ^ false ].	^ true! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/10/2016 18:27'!load	^ load ifNil: [ load := #() ]! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:46'!load: required	load := required! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 02:39'!platforms	^ platforms ifNil: [ platforms := OrderedCollection new ]! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 02:39'!platforms: platformCollection	platforms := platformCollection! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:44'!repository	^ repository! !!SCIMetacelloLoadSpec methodsFor: 'accessing' stamp: 'fn 1/10/2016 11:44'!repository: aRepository	repository := aRepository! !Object subclass: #SCIReport	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: 'SmalltalkCI-Core'!!SCIReport commentStamp: 'TorstenBergmann 2/12/2014 22:30' prior: 0!A Hudson report!!SCIReport methodsFor: 'private' stamp: 'lr 5/15/2010 14:27'!convert: aString
  ^ (aString asString 
    copyReplaceAll: (String with: Character cr with: Character lf) with: (String with: Character lf))
    copyReplaceAll: (String with: Character cr) with: (String with: Character lf)! !!SCIReport methodsFor: 'private' stamp: 'lr 5/14/2010 08:36'!encode: aString
  ^ ((aString asString 
    copyReplaceAll: '&' with: '&amp;') 
    copyReplaceAll: '"' with: '&quot;') 
    copyReplaceAll: '<' with: '&lt;'! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!SCIReport class	instanceVariableNames: ''!!SCIReport class methodsFor: 'compatibility' stamp: 'fn 1/10/2016 11:01'!classesInCategory: category	^ (Smalltalk organization listAtCategoryNamed: category) collect: [ :className | Smalltalk at: className ]! !!SCIReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:17'!runCategories: aCollectionOfStrings
  ^ aCollectionOfStrings do: [ :each | self runCategory: each ]! !!SCIReport class methodsFor: 'running' stamp: 'fn 1/10/2016 11:02'!runCategory: aString
  ^ self runClasses: (self classesInCategory: aString) named: aString! !!SCIReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:15'!runClasses: aCollectionOfClasses named: aString
  self subclassResponsibility! !!SCIReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:16'!runPackage: aString
  self subclassResponsibility! !!SCIReport class methodsFor: 'running' stamp: 'EstebanLorenzano 8/21/2015 07:16'!runPackages: aCollectionOfStrings
  ^ aCollectionOfStrings collect: [ :each | self runPackage: each ]! !StandardToolSet subclass: #SCISqueakToolSet	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: 'SmalltalkCI-Core'!"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!SCISqueakToolSet class	instanceVariableNames: ''!!SCISqueakToolSet class methodsFor: 'class initialization' stamp: 'fn 1/12/2016 22:52'!unload	ToolSet unregister: self! !!SCISqueakToolSet class methodsFor: 'debugging' stamp: 'fn 1/12/2016 22:53'!debugError: anError	"Print out a sensible stack trace and bail"	| problemPlace s |	problemPlace := anError signalerContext.	s := FileStream stderr.	(anError isKindOf: MessageNotUnderstood) ifTrue: [		s			nextPutAll: anError messageText; cr;			nextPutAll: problemPlace sender methodNode printString; cr].	(problemPlace stackOfSize: 20) do: [:ctx | s cr. ctx printOn: s].	s flush.	SmalltalkImage current snapshot: false andQuitWithExitCode: 1! !!SCISqueakToolSet class methodsFor: 'debugging' stamp: 'fn 1/12/2016 22:53'!debugSyntaxError: anError	| s |	s := FileStream stderr.	s nextPutAll: '----- Syntax error -----'; cr.	s nextPutAll: anError errorCode; cr.	s nextPutAll: '----- Syntax error -----'; cr.	self debugError: anError! !SCIReport subclass: #SCITestReport	instanceVariableNames: 'suite stream suitePosition suiteTime suiteFailures suiteErrors progressFile'	classVariableNames: ''	poolDictionaries: ''	category: 'SmalltalkCI-Core'!!SCITestReport commentStamp: 'TorstenBergmann 2/12/2014 22:31' prior: 0!Hudson report for test results!!SCITestReport methodsFor: 'initialization' stamp: 'fn 1/12/2016 23:00'!initialize
  super initialize.
  suiteTime := 0 asDuration.
  suitePosition := suiteFailures := suiteErrors := 0.
  progressFile := StandardFileStream stdout
  ! !!SCITestReport methodsFor: 'initialization' stamp: 'EstebanLorenzano 8/26/2015 12:06'!initializeOn: aTestSuite
  suite := aTestSuite! !!SCITestReport methodsFor: 'running' stamp: 'IgorStasenko 1/6/2012 15:12'!done
  "just close the file"
  [ progressFile close ] on: Error do: []! !!SCITestReport methodsFor: 'running' stamp: 'fn 1/10/2016 10:56'!run
	[ 
      	self setUp.
      	suiteTime := [ self runAll ]
        		timeToRun ]
          			ensure: [ self tearDown ]! !!SCITestReport methodsFor: 'running' stamp: 'fniep 1/12/2016 22:15'!runAll
  suite tests do: [ :each | each run: self ]! !!SCITestReport methodsFor: 'running' stamp: 'MaxLeske 11/6/2013 10:03'!runCase: aTestCase
  | error stack  |
  self 
    beginTestCase: aTestCase
    runBlock: [ [ [ aTestCase runCase ] 
      on: Halt , Error, TestFailure
      do: [ :err |
        error := err.
        aTestCase isExpectedFailure ifFalse: [self serializeError: error of: aTestCase].
        stack := self stackTraceString: err of: aTestCase ]]
      on: TestSkip do: [ :err| "nothing to do..." ] ].
    
  (error isNil or: [aTestCase isExpectedFailure])  ifFalse: [
    (error isKindOf: TestFailure)
      ifTrue: [ self writeError: error stack: stack ]
      ifFalse: [ self writeFailure: error stack: stack ]].
    
  self endTestCase! !!SCITestReport methodsFor: 'running' stamp: 'AndreiChis 10/7/2013 11:59'!serializeError: error of: aTestCase
  "We got an error from a test, let's serialize it so we can properly debug it later on..."
  | context testCaseMethodContext |
  
  context := error signalerContext.
  testCaseMethodContext := context findContextSuchThat: [ :ctx| 
    ctx receiver == aTestCase and: [ ctx methodSelector == #performTest ]].
  context := context copyTo: testCaseMethodContext.
  
  [ FuelOutStackDebugAction
    serializeTestFailureContext: context sender     
    toFileNamed: aTestCase class name asString,'-', aTestCase selector, '.fuel' ] 
  on: Error 
  do: [:err| "simply continue..." ]

! !!SCITestReport methodsFor: 'running' stamp: 'DamienCassou 2/20/2014 16:54'!setUp
  progressFile nextPutAll: 'running suite: ';
    nextPutAll: suite name ; crlf; flush.
    
  stream := StandardFileStream forceNewFileNamed: suite name , '-Test.xml'.
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
      ifFalse: [ each signalInitializationError ] ]! !!SCITestReport methodsFor: 'running' stamp: 'fn 1/13/2016 00:10'!tearDown
  suite resources 
    do: [ :each | each reset ].
    
  stream tab; nextPutAll: '<system-out><!![CDATA[]]></system-out>'; lf.
  stream tab; nextPutAll: '<system-err><!![CDATA[]]></system-err>'; lf.
  stream nextPutAll: '</testsuite>'.
  
  stream position: suitePosition.
  stream 
    nextPutAll: ' failures="'; print: suiteFailures; 
    nextPutAll: '" errors="'; print: suiteErrors; 
    nextPutAll: '" time="'; print: suiteTime / 1000.0; 
    nextPutAll: '">'.
  stream close.
  
  progressFile 
    nextPutAll: 'finished running suite: ';
    nextPutAll: suite name! !!SCITestReport methodsFor: 'accessing' stamp: 'EstebanLorenzano 8/21/2015 07:43'!suiteErrors
  ^ suiteErrors! !!SCITestReport methodsFor: 'accessing' stamp: 'EstebanLorenzano 8/21/2015 07:42'!suiteFailures
  ^ suiteFailures! !!SCITestReport methodsFor: 'accessing' stamp: 'EstebanLorenzano 8/21/2015 07:48'!suitePassing 
  ^ self suiteTotal - self suiteFailures - self suiteErrors! !!SCITestReport methodsFor: 'accessing' stamp: 'EstebanLorenzano 8/21/2015 08:02'!suiteTotal
  ^ suite 
    ifNotNil: [ suite tests size ]
    ifNil: [ 0 ]! !!SCITestReport methodsFor: 'testing' stamp: 'EstebanLorenzano 8/21/2015 07:29'!hasFailuresOrErrors 
  ^ suiteFailures ~= 0 or: [ suiteErrors ~= 0 ]! !!SCITestReport methodsFor: 'private' stamp: 'fn 1/10/2016 10:57'!beginTestCase: aTestCase runBlock: aBlock
  | time |
  progressFile 
    nextPutAll: 'starting testcase: ' ; 
    nextPutAll: aTestCase class name; 
    nextPutAll:'>>';
    nextPutAll: aTestCase selector; 
    nextPutAll: ' ... '; 
    flush.
    
  time := aBlock timeToRun.
  stream tab; 
    nextPutAll: '<testcase classname="'; 
    nextPutAll: (self encode: (aTestCase class category copyReplaceAll: '-' with: '.')); 
    nextPut: $.; nextPutAll: (self encode: aTestCase class name); 
    nextPutAll: '" name="'; nextPutAll: (self encode: aTestCase selector); 
    nextPutAll: '" time="'; print: (time / 1000.0); 
    nextPutAll: '">'; lf
  
! !!SCITestReport methodsFor: 'private' stamp: 'CamilloBruni 11/4/2013 08:29'!endTestCase
  stream tab; nextPutAll: '</testcase>'; lf.
  progressFile nextPutAll: 'finished' ; crlf; flush.
! !!SCITestReport methodsFor: 'private' stamp: 'CamilloBruni 11/4/2013 08:27'!stackTraceString: err of: aTestCase
  ^ String streamContents: [ :str | 
    | context |
    context := err signalerContext.
    [ context isNil or: [ context receiver == aTestCase and: [ context methodSelector == #runCase ] ] ] whileFalse: [
      str print: context; lf.
      context := context sender ] ] ! !!SCITestReport methodsFor: 'private' stamp: 'CamilloBruni 11/4/2013 08:27'!writeError: error stack: stack
  suiteErrors := suiteErrors + 1.
  stream tab; tab; nextPutAll: '<error type="'.
  self writeException: error stack: stack.
  stream nextPutAll: '</error>'; lf! !!SCITestReport methodsFor: 'private' stamp: 'CamilloBruni 7/20/2012 16:53'!writeException: error stack: stack.

  stream 
    nextPutAll: (self encode: error class name); 
    nextPutAll: '" message="'; nextPutAll: (self encode: (error messageText ifNil: [ error description ])); 
    nextPutAll: '">'; 
    nextPutAll: (self encode: stack).! !!SCITestReport methodsFor: 'private' stamp: 'CamilloBruni 11/4/2013 08:27'!writeFailure: error stack: stack
  suiteFailures := suiteFailures + 1.
  stream tab; tab; nextPutAll: '<failure type="'.
  self writeException: error stack: stack.  
  stream  nextPutAll: '</failure>'; lf! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!SCITestReport class	instanceVariableNames: ''!!SCITestReport class methodsFor: 'running' stamp: 'EstebanLorenzano 8/25/2015 16:00'!runClasses: aCollectionOfClasses named: aString
  | suite classes |
  suite := TestSuite named: aString.
  classes := (aCollectionOfClasses
    select: [ :each | (each includesBehavior: TestCase) and: [ each isAbstract not ] ])
      asSortedCollection: [ :a :b | a name <= b name ].
  classes isEmpty
    ifTrue: [ ^ nil ].
  classes
    do: [ :each | each addToSuiteFromSelectors: suite ].
  ^ self runSuite: suite! !!SCITestReport class methodsFor: 'running' stamp: 'CamilloBruni 8/30/2013 13:37'!runPackage: aString
  ^ self runClasses: (RPackage organizer packageNamed: aString) definedClasses named: aString! !!SCITestReport class methodsFor: 'running' stamp: 'EstebanLorenzano 8/26/2015 12:06'!runSuite: aTestSuite
  ^ self new
    initializeOn: aTestSuite; 
    run;
    done! !Object subclass: #SmalltalkCISpec	instanceVariableNames: 'loadSpecs projectDirectory testing'	classVariableNames: ''	poolDictionaries: ''	category: 'SmalltalkCI-Core'!!SmalltalkCISpec methodsFor: 'testing' stamp: 'fniep 1/12/2016 22:15'!getTestClasses	| classes excludedClasses |	classes := OrderedCollection new.	classes addAll: (self getTestClasses: self testing).	excludedClasses := OrderedCollection new.	self testing at: #exclude ifPresent: [ :excludeDict |		excludedClasses addAll: (self getTestClasses: excludeDict ) ].	^ classes select: [ :cl | (excludedClasses includes: cl) not ]! !!SmalltalkCISpec methodsFor: 'testing' stamp: 'fniep 1/11/2016 23:14'!getTestClasses: aDict	| classes |	classes := OrderedCollection new.	aDict at: #classes ifPresent: [ :cs |		cs do: [ :clString |			Smalltalk at: clString				ifPresent: [ :cl | classes add: cl ] ] ].	aDict at: #categories ifPresent: [ :categories |		categories do: [ :category |			classes addAll: (SCIReport classesInCategory: category) ] ].	^ classes! !!SmalltalkCISpec methodsFor: 'testing' stamp: 'fniep 1/11/2016 23:32'!testProject	SCITestReport runClasses: self getTestClasses named: 'SmalltalkCI Testsuite' ! !!SmalltalkCISpec methodsFor: 'loading' stamp: 'fniep 1/11/2016 02:43'!loadProject	"Install all specs for the current platform"	(self loadSpecs		select: [ :aSpec | aSpec isPlatformCompatible ])			do: [ :aSpec | aSpec loadProject: self projectDirectory ]! !!SmalltalkCISpec methodsFor: 'accessing' stamp: 'fniep 1/10/2016 23:50'!addLoadSpec: aLoadSpec	aLoadSpec isComplete ifTrue: [ self loadSpecs add: aLoadSpec ]! !!SmalltalkCISpec methodsFor: 'accessing' stamp: 'fniep 1/10/2016 23:54'!loadSpecs	^ loadSpecs ifNil: [ loadSpecs := OrderedCollection new ]! !!SmalltalkCISpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 00:33'!loadSpecs: loadSpecifications	loadSpecs := loadSpecifications! !!SmalltalkCISpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 00:17'!projectDirectory	^ projectDirectory! !!SmalltalkCISpec methodsFor: 'accessing' stamp: 'fniep 1/11/2016 00:17'!projectDirectory: aDirectory	projectDirectory := aDirectory! !!SmalltalkCISpec methodsFor: 'accessing' stamp: 'fniep 1/12/2016 22:15'!testing	^ testing ifNil: [ testing := Dictionary new ]! !!SmalltalkCISpec methodsFor: 'accessing' stamp: 'fniep 1/12/2016 22:15'!testing: aDictionary	testing := aDictionary! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!SmalltalkCISpec class	instanceVariableNames: ''!!SmalltalkCISpec class methodsFor: 'helpers' stamp: 'fn 1/12/2016 22:31'!platformSymbol	| versionString |  	Smalltalk at: #'SystemVersion'    		ifPresent: [ :cl |       		versionString := cl current version.      		(versionString beginsWith: 'Pharo')        			ifTrue: [ ^ #'pharo' ].      		(versionString beginsWith: 'Squeak')        			ifTrue: [ ^ #'squeak' ].      		self error: 'Unrecognized version of Squeak/Pharo: ' , versionString ].  	^ #'gemstone'! !!SmalltalkCISpec class methodsFor: 'helpers' stamp: 'fn 1/13/2016 00:00'!runsHeadless	self platformSymbol = #squeak		ifTrue: [ ^ Smalltalk vm options includesAnyOf: #('-headless' '-nodisplay') ].	self platformSymbol = #pharo		ifTrue: [ ^ Smalltalk vm options includes: '--headless' ].	self platformSymbol = #gemstone		ifTrue: [ ^ true ].	^ false! !!SmalltalkCISpec class methodsFor: 'installing' stamp: 'fniep 1/11/2016 00:21'!initialize	"self initialize"	self requireSTON! !!SmalltalkCISpec class methodsFor: 'installing' stamp: 'fniep 1/11/2016 01:30'!installSTON	self stonInstalled ifFalse: [		Smalltalk at: #Installer ifPresent: [ :installer |    			[ installer squeaksource3      			project: 'STON';      			addPackage: 'STON-Core';      			install ] on: Warning do: [ :x | x resume ] ] ].	self stonInstalled ifFalse: [		Smalltalk at: #Gofer ifPresent: [ :gofer |    			[ gofer new      			url: 'http://ss3.gemstone.com/ss/STON';      			package: 'STON-Core';      			load ] on: Warning do: [ :x | x resume ] ] ].	self stonInstalled ifFalse: [		Smalltalk at: #Metacello ifPresent: [ :metacello |    			[ metacello new      			configuration: 'STON';      			version: #stable;      			repository: 'http://ss3.gemstone.com/ss/STON';      			load ] on: Warning do: [ :x | x resume ] ] ]! !!SmalltalkCISpec class methodsFor: 'installing' stamp: 'fniep 1/11/2016 00:21'!requireSTON	self stonInstalled ifFalse: [    		self installSTON.    		self stonInstalled ifFalse: [      		self error: 'STON could not be loaded.' ] ]  ! !!SmalltalkCISpec class methodsFor: 'installing' stamp: 'fniep 1/11/2016 00:21'!stonInstalled	^ Smalltalk includesKey: #STON! !!SmalltalkCISpec class methodsFor: 'instance creation' stamp: 'fn 1/12/2016 23:19'!automatedTestOf: aFilenameString	self prepareForAutomatedTest.	self loadAndTestFromSTONFile: aFilenameString.	self finishUpAutomatedTest.		self runsHeadless ifFalse: [ ^ self ].	Smalltalk at: #WorldState ifPresent: [:global |		global addDeferredUIMessage: [    			Smalltalk at: #SmalltalkImage ifPresent: [:image |     	 			image current snapshot: true andQuit: true ]]]! !!SmalltalkCISpec class methodsFor: 'instance creation' stamp: 'fn 1/12/2016 23:19'!finishUpAutomatedTest	(self platformSymbol = #squeak and: [ self runsHeadless ])		ifTrue: [ SCISqueakToolSet unload ]! !!SmalltalkCISpec class methodsFor: 'instance creation' stamp: 'fniep 1/11/2016 00:26'!fromSTONFile: aFilenameString	| stream spec |	stream := StandardFileStream oldFileNamed: aFilenameString.  	stream := MultiByteFileStream newFrom: stream.	spec := self fromSTONFileStream: stream.	stream close.	^ spec! !!SmalltalkCISpec class methodsFor: 'instance creation' stamp: 'fniep 1/11/2016 00:11'!fromSTONFileStream: aStream	| directory spec |	spec := STON fromStream: aStream.	directory := aStream directory fullName.	spec projectDirectory: directory.  	^ spec  ! !!SmalltalkCISpec class methodsFor: 'instance creation' stamp: 'fniep 1/11/2016 00:27'!loadAndTestFromSTONFile: aFilenameString	(self fromSTONFile: aFilenameString)		loadProject;		testProject! !!SmalltalkCISpec class methodsFor: 'instance creation' stamp: 'fniep 1/11/2016 00:23'!loadFromSTONFile: aFilenameString	(self fromSTONFile: aFilenameString) loadProject! !!SmalltalkCISpec class methodsFor: 'instance creation' stamp: 'fn 1/12/2016 22:47'!prepareForAutomatedTest	(self platformSymbol = #squeak and: [ self runsHeadless ])		ifTrue: [			ToolSet register: SCISqueakToolSet.			ToolSet default: SCISqueakToolSet ]! !SmalltalkCISpec initialize!