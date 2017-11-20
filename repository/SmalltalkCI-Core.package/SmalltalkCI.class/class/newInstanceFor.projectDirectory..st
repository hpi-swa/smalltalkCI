instance creation
newInstanceFor: aFilename projectDirectory: aProjectDirectory
	^ self newInstance
		spec: (SmalltalkCISpec fromFile: aFilename);
		projectDirectory: aProjectDirectory;
		yourself