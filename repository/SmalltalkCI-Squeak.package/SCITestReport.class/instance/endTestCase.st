private
endTestCase
  stream tab; nextPutAll: '</testcase>'; lf.
  progressFile nextPutAll: 'finished'; cr; flush.
