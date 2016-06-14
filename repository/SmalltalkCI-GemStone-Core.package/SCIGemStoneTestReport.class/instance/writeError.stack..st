private
writeError: error stack: stack
  suiteErrors := suiteErrors + 1.
  self stream
    tab;
    tab;
    nextPutAll: '<error type="'.
  self writeException: error stack: stack.
  self stream
    nextPutAll: '</error>';
    lf