private
endTestCase
  stream tab; nextPutAll: '</testcase>'; lf.
  progressFile nextPut: $>; flush.
