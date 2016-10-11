private
serializeError: error of: aTestCase
  (Smalltalk at: #DebuggerLogEntry)
    createContinuationLabeled: self suiteName , ': ' , aTestCase printString.
  (Smalltalk at: #System) commitTransaction
    ifFalse: [ 
      Transcript
        cr;
        show: 'Commit failed attempting to log test case defect' ]