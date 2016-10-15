public-api
defaultSessionName
  ^ DefaultSessionName ifNil: [ DefaultSessionName := 'travis' ]