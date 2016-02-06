private
recordUnexpectedPassFor: aTestCase
  (ObjectLogEntry
    error:
      'UNEXPECTED PASS: ' , self spec specName , ': ' , aTestCase printString
    object:
      {'unexpected pass'.
      aTestCase}) addToLog.
  System commit