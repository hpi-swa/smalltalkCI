public-api
load: fullPathToConfig projectDirectory: aProjectDirectory
	^ (self newInstanceFor: fullPathToConfig projectDirectory: aProjectDirectory)
		load