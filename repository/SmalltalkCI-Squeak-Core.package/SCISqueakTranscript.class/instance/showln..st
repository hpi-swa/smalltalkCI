overrides
showln: anObject
    super showln: anObject.
    "Print to stdout for TravisCI"
    FileStream stdout cr; nextPutAll: anObject asString.