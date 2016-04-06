accessing
defaultSessionName
	^ DefaultSessionName ifNil: [ DefaultSessionName := 'travis' ]