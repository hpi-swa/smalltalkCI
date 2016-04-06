accessing
defaultSessionName
	^ DefaultSessionName ifNil: [ DefaultSessionName := 'Travis' ]