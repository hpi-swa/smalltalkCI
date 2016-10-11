testing
loadedClasses
  self baseline
    ifNotNil: [ :b | ^ self getClassesForMetacelloProjectRegistration: 'BaselineOf' , b ].
  self configuration
    ifNotNil: [ :c | ^ self getClassesForMetacelloProjectRegistration: 'ConfigurationOf' , c ].
  ^ #()