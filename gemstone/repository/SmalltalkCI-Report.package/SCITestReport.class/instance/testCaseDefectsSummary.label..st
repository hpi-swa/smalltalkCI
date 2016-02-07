private
testCaseDefectsSummary: testCases label: label
  progressFile
    tab;
    nextPutAll: label;
    cr.
  testCases
    do: [ :each | 
      progressFile
        tab;
        tab;
        nextPutAll: each printString;
        cr ]