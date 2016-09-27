overrides
showln: anObject
    super showln: anObject.
    "Print to stdout for fn"
    SmalltalkCI stdout cr; nextPutAll: anObject asString.