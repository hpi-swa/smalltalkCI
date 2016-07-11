instance creation
writeOn: aStream
	(STON writer on: aStream)
		prettyPrint: true;
		jsonMode: false;
		referencePolicy: #error;
		nextPut: self