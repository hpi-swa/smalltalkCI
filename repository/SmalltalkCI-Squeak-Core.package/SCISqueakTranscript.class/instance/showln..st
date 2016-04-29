overrides
showln: anObject
    super showln: anObject.
    "Print to stdout for fn"
    FileStream stdout cr; nextPutAll: anObject asString.