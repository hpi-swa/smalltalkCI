testing
loadedClasses
  self baseline
    ifNotNil: [ :b | ^ self getClassesForMetacelloProjectRegistration: b ].
  self configuration
    ifNotNil: [ :c | ^ self getClassesForMetacelloProjectRegistration: c ].
  ^ #()