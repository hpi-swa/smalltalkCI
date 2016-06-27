class organization
classesForPackages: unresolvedPackageNames
	| resolvedNames |
	resolvedNames := self resolveAll: unresolvedPackageNames with: self allPackageNames.
	^ self classesWithPackageNames: resolvedNames