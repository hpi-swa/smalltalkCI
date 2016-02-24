private
serializeError: error of: aTestCase
  DebuggerLogEntry
    createContinuationLabeled: suite name , ': ' , aTestCase printString.
  System commitTransaction
    ifFalse: [ 
      Transcript
        cr;
        show: 'Commit failed attempting to log test case defect' ]