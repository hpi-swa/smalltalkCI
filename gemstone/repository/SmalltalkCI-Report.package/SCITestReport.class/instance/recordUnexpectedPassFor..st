private
recordUnexpectedPassFor: aTestCase
  (ObjectLogEntry
    error: self spec specName , ': ' , aTestCase printString
    object:
      {'unexpected pass'.
      aTestCase}) addToLog.
  System commit