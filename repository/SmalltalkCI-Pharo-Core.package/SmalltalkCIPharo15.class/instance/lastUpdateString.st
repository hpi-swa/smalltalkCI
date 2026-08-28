accessing
lastUpdateString

	^ 'Build information: ' , (SystemVersion current
		ifNil: [ 'No version set yet' ]
		ifNotNil: [ :version | version asString ])
