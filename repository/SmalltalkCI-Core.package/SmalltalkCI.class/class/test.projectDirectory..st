public-api
test: fullPathToConfig projectDirectory: aDirectoryPathString
	^ self
		test: fullPathToConfig
		named: nil
		projectDirectory: aDirectoryPathString