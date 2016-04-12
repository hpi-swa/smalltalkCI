executing
runCIFor: aFilename
	self reportImage.
	self readSTONSpec: aFilename.
	^ self runCI