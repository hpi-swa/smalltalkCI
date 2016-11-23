class organization
classesForPackages: unresolvedPackageNames
	^ self classesWithPackageNames: (self resolvedPackageNames: unresolvedPackageNames)