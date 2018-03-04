printing
printOn: aStream
	aStream nextPutAll: 'FROM'; space.
	baseImage ifNotNil: [ aStream nextPutAll: self baseImage ]