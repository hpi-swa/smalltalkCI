class organization
extensionMethodsInPackage: packageName

	^ (self packageNamed: packageName ifAbsent: [^ #()]) extensionMethods