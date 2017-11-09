public-api
load: fullPathToConfig
	^ self
		load: fullPathToConfig
		projectDirectory: (self dirname: fullPathToConfig)