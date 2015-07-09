'From Pharo1.4 of 18 April 2012 [Latest update: #14457] on 4 September 2012 at 6:40:36 pm'!
Object subclass: #MetacelloBuilderTravisCI
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'XXX'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MetacelloBuilderTravisCI class
	instanceVariableNames: ''!

!MetacelloBuilderTravisCI class methodsFor: 'git' stamp: 'dkh 9/4/2012 18:36'!
gitPath
    ^ self gitPathFor: 'git_cache'! !

!MetacelloBuilderTravisCI class methodsFor: 'git' stamp: 'dkh 9/4/2012 18:33'!
gitPathFor: gitCacheName
    ^ (Smalltalk at: #'FileDirectory' ifAbsent: [  ])
        ifNil: [ 
            "Pharo-2.x"
            (((Smalltalk at: #'FileSystem') perform: #workingDirectory) / gitCacheName) pathString ]
        ifNotNil: [ :fileDirectoryClass | 
            "Pharo-1.x"
            (fileDirectoryClass default directoryNamed: gitCacheName) fullName ]! !


!MetacelloBuilderTravisCI class methodsFor: 'retry' stamp: 'dkh 9/4/2012 18:28'!
retry: aBlock
    self retry: aBlock retryCount: 3! !

!MetacelloBuilderTravisCI class methodsFor: 'retry' stamp: 'dkh 9/4/2012 18:28'!
retry: aBlock retryCount: retryCount
    | count |
    count := 1.
    [ true ]
        whileTrue: [ 
            [ 
            aBlock value.
            ^ self ]
                on: Error
                do: [ :ex | 
                    count < retryCount
                        ifTrue: [ 
                            Transcript
                                cr;
                                show: 'RETRYING AFTER:';
                                cr;
                                show: ex description printString.
                            (Delay forSeconds: 10) wait.]
                        ifFalse: [ 
                            Transcript
                                cr;
                                show: 'FAILED RETRYING:';
                                cr;
                                show: ex description printString.
                            ex pass ] ].
            count := count + 1 ]! !


!MetacelloBuilderTravisCI class methodsFor: 'test harness' stamp: 'dkh 9/4/2012 18:31'!
runHarnessFor: configurationClassNameList successFilename: successFilename failFilename: failFilename
    | suite |
    suite := TestCase suiteClass named: configurationClassNameList printString , ' Test Suite'.
    configurationClassNameList
        do: [ :className | 
            (((Smalltalk at: #'MetacelloProjectRegistration')
                registrationForClassNamed: className
                ifAbsent: [ self error: className printString , ' not registered (loaded)' ])
                currentlyLoadedClassesInProject select: [ :cl | cl inheritsFrom: TestCase ])
                do: [ :cl | 
                    cl isAbstract
                        ifFalse: [ suite addTest: cl buildSuiteFromSelectors ] ] ].
    self runTestSuite: suite successFilename: successFilename failFilename: failFilename! !

!MetacelloBuilderTravisCI class methodsFor: 'test harness' stamp: 'dkh 11/20/2014 15:56'!
runTestSuite: suite successFilename: successFilename failFilename: failFilename
    [ 
    | result resultsFileName |
    result := suite run.
    resultsFileName := result defects isEmpty
        ifTrue: [ successFilename ]
        ifFalse: [ failFilename ].
    (Smalltalk at: #'TravisResultFileBlock')
        value: resultsFileName
        value: [ :fileStream |
            fileStream
                lf;
                nextPutAll: '**************************************************************************************';
                lf.
            fileStream
                tab;
                nextPutAll: 'Results for ' , suite name;
                lf;
                nextPutAll: result printString;
                lf.
            fileStream
                nextPutAll: '**************************************************************************************';
                lf.
            result failures notEmpty
                ifTrue: [ 
                    fileStream
                        nextPutAll: '*** FAILURES ***';
                        nextPutAll: '****************';
                        lf ].
            result failures
                do: [ :each | 
                    fileStream tab
                        nextPutAll: each class name asString , ' debug: ' , each selector printString , '.';
                        lf ].
            result errors notEmpty
                ifTrue: [ 
                    fileStream
                        nextPutAll: '*** ERRORS ***';
                        nextPutAll: '****************';
                        lf ].
            result errors
                do: [ :each | 
                    fileStream tab
                        nextPutAll: each class name asString , ' debug: ' , each selector printString , '.';
                        lf ].
            fileStream
                nextPutAll: '**************************************************************************************';
                lf ] ]
        ensure: [
            (Transcript respondsTo: #close)
              ifTrue: [
                | stream |
                stream := Transcript.
                (Smalltalk globals associationAt: #'Transcript') value: (Smalltalk at: #'OLDTranscript').
                stream close ]]! !


!MetacelloBuilderTravisCI class methodsFor: 'filein' stamp: 'dkh 9/4/2012 18:33'!
fileIn: fileName
    (Smalltalk at: #'FileDirectory' ifAbsent: [  ])
        ifNil: [ ((Smalltalk at: #'FileSystem') perform: #workingDirectory) / fileName readStreamDo: [ :fileStream | fileStream fileIn ] ]
        ifNotNil: [ :fileDirectoryClass | fileDirectoryClass default fileNamed: fileName do: [ :fileStream | fileStream fileIn ] ]! !


!MetacelloBuilderTravisCI class methodsFor: 'test harness' stamp: 'dkh 06/11/2014 7:44'!
successOnNoFailures: successFilename 

(Smalltalk at: #'TravisResultFileBlock')
  value: successFilename
  value: [ :fileStream |
    fileStream
      lf;
      nextPutAll: '**************************************************************************************';
      lf;
      tab;
      nextPutAll: 'No failures..';
      lf;
      nextPutAll: '**************************************************************************************';
      lf].
 (Transcript respondsTo: #close)
   ifTrue: [
     | stream |
     stream := Transcript.
     (Smalltalk globals associationAt: #'Transcript') value: (Smalltalk at: #'OLDTranscript').
     stream close ].! !

