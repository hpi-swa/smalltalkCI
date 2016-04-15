accessing
suiteName
  ^ suiteName ifNil: [ ^ self class defaultSuiteName ]