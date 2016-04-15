overrides
show: anObject
    super show: anObject.
    "Print to stdout for TravisCI"
    FileStream stdout nextPutAll: anObject asString.