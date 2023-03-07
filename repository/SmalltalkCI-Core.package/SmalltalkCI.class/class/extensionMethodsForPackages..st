class organization
extensionMethodsForPackages: unresolvedPackageNames

	^ self extensionMethodsForPackageNames:
		(self resolvedPackageNames: unresolvedPackageNames)