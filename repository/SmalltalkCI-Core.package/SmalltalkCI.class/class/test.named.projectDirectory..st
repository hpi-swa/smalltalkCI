public-api
test: fullPathToConfig named: aName projectDirectory: aProjectDirectory
	| instance |
	instance := self newInstanceFor: fullPathToConfig projectDirectory: aProjectDirectory.
	instance spec name: aName.
	^ instance test