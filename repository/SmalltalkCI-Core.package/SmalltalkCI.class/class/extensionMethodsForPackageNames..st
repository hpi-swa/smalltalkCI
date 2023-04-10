class organization
extensionMethodsForPackageNames: packageNames

	^ packageNames gather: [:packageName |
		self extensionMethodsInPackage: packageName]