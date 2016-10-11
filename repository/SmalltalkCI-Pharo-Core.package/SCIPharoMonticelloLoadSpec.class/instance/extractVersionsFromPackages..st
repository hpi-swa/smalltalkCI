executing
extractVersionsFromPackages: aRepository
	self packages do: [ :pkg | 
		(aRepository allFileNamesOrCache
			select: [ :filename | (filename copyUpToLast: $-) = pkg ])
			ifEmpty: [ self error: 'No version for "', pkg ,'" found in ', aRepository asString ]
			ifNotEmptyDo: [ :versionNames |
				self versions add: (versionNames detectMax: [ :ea | self versionNumberOf: ea ] ) ]]