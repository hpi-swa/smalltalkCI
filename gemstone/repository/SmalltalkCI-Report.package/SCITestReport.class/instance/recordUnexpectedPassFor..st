private
recordUnexpectedPassFor: aTestCase
  (ObjectLogEntry
    error: 'UNEXPECTED PASS: ' , suite name , ': ' , aTestCase printString
    object:
      {'unexpected pass'.
      aTestCase}) addToLog.
  System commitTransaction
    ifFalse: [ 
      Transcript
        cr;
        show: 'Commit failed attempting to log unexpected pass' ]