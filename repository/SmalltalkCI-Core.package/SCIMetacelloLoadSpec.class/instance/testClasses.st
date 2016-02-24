accessing
testClasses
  self baseline
    ifNotNil: [ :b | ^ self getTestClassesForMetacelloProjectRegistration: b ].
  self configuration
    ifNotNil: [ :c | ^ self getTestClassesForMetacelloProjectRegistration: c ].
  ^ #()