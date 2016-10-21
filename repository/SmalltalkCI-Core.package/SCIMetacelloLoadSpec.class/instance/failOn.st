accessing
failOn
	failOn ifNil: [ failOn := #() ].
	^ failOn