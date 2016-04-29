overrides
crlf
    super cr.
    "Print to stdout for fn"
    FileStream stdout nextPut: Character cr; nextPut: Character lf.