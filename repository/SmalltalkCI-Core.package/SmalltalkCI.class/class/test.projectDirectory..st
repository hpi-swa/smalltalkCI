public-api
test: fullPathToConfig projectDirectory: aDirectoryPathString
	 ^ self newInstance
    readSTONSpec: fullPathToConfig;
    projectDirectory: aDirectoryPathString;
    test