private
writeFailure: error stack: stack
  suiteFailures := suiteFailures + 1.
  self stream
    tab;
    tab;
    nextPutAll: '<failure type="'.
  self writeException: error stack: stack.
  self stream
    nextPutAll: '</failure>';
    lf