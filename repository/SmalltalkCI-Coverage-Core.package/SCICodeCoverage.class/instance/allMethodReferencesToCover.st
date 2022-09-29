helpers
allMethodReferencesToCover

	| methods |
	methods := self class methodReferencesFor: self allClassesToCover.
	
	methods := methods , self extensionMethodsForPackages asArray.
	
	^ methods