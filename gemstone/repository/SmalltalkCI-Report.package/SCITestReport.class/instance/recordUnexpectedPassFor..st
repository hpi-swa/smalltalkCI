private
recordUnexpectedPassFor: aTestCase
  (ObjectLogEntry
    error: 'UNEXPECTED PASS: ' , suite name , ': ' , aTestCase printString
    object:
      {'unexpected pass'.
      aTestCase}) addToLog.
  System commit