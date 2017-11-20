public-api
test: fullPathToConfig named: aName
	^ self test: fullPathToConfig named: aName projectDirectory: (self dirname: fullPathToConfig)