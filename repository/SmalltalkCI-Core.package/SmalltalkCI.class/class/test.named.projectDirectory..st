public-api-deprecated
test: aFilenameString named: aName projectDirectory: aProjectDirectory
	self deprecated: 'Custom name no longer supported, use SmalltalkCI class>>test:projectDirectory: instead.'.
	^ self test: aFilenameString projectDirectory: aProjectDirectory