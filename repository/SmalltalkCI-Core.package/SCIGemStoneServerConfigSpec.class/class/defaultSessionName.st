accessing
defaultSessionName
  ^ defaultSessionName ifNil: [ defaultSessionName := 'travis' ]