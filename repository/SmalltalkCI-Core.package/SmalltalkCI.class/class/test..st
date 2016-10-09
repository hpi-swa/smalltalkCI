public-api
test: aFilenameString
	^ self test: aFilenameString named: (self defaultSuiteName: aFilenameString)