overrides
show: anObject
    super show: anObject.
    "Print to stdout for fn"
    FileStream stdout nextPutAll: anObject asString.