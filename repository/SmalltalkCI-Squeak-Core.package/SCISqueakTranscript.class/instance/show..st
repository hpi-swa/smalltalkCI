overrides
show: anObject
    super show: anObject.
    "Print to stdout for fn"
    SmalltalkCI stdout nextPutAll: anObject asString.