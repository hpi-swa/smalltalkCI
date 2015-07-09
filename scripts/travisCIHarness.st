"builderCI test harness ... invoked by the following expression:

    TravisCIHarness
      value: #( 'BaselineOfFileTreeTests' 'ConfigurationOfMetacello')
      value: 'TravisCISuccess.txt' 
      value: 'TravisCIFailure.txt'.

"

    Smalltalk
        at: #'TravisCIHarness'
        put: [ :configurationClassNameList :successFilename :failFilename |
          MetacelloBuilderTravisCI 
            runHarnessFor: configurationClassNameList 
            successFilename: successFilename 
            failFilename: failFilename].

"Use this expression when you want to indicate that you had successful run
  just by surviving ... no explicit tests to run

    TravisCISuccessNoFailure
      value: 'TravisCISuccess.txt'.
"

    Smalltalk
        at: #'TravisCISuccessNoFailure'
        put: [ :successFilename  |
          MetacelloBuilderTravisCI successOnNoFailures: successFilename ].

"Use this expression when you want to a custom TestSuite" 

    Smalltalk
        at: #'TravisCISuiteHarness'
        put: [ :suite :successFilename :failFilename |
          MetacelloBuilderTravisCI 
            runTestSuite: suite 
            successFilename: successFilename 
            failFilename: failFilename].

