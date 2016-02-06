private
recordUnexpectedPassFor: aTestCase
  (ObjectLogEntry
    error: 'UNEXPECTED PASS: ' , suite suiteName , ': ' , aTestCase printString
    object:
      {'unexpected pass'.
      aTestCase}) addToLog.
  System commit