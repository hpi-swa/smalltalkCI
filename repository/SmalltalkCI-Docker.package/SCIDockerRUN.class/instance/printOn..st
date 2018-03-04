printing
printOn: aStream
	comment ifNotNil: [ aStream print: self comment; lf ].
	aStream nextPutAll: self instruction