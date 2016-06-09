executing
extractVersionsFromPackages: aRepository
	self packages do: [ :pkg | | versionNames |
		versionNames := aRepository versionNamesForPackageNamed: pkg.
		versionNames
			ifEmpty: [ self error: 'No version for "', pkg asString ,'" found in ', aRepository asString ]
			ifNotEmpty: [ self versions add: versionNames first ] ]