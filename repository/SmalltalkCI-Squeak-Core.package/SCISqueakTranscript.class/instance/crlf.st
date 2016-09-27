overrides
crlf
    super cr.
    "Print to stdout for fn"
    SmalltalkCI stdout nextPut: Character cr; nextPut: Character lf.