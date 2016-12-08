printing
printOn: aStream
  "note - both asString and printOn: need to be implemented for portability"

  aStream nextPutAll: self asString