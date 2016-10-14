public-api
defaultSessionName
  ^ defaultSessionName ifNil: [ defaultSessionName := 'travis' ]