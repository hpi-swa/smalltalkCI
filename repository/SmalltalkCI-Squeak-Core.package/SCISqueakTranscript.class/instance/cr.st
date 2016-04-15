overrides
cr
    super cr.
    "Print to stdout for TravisCI"
    FileStream stdout nextPut: Character cr.