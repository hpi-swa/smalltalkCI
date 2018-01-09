public-api
test: fullPathToConfig
	^ self
		test: fullPathToConfig
		projectDirectory: (self dirname: fullPathToConfig)