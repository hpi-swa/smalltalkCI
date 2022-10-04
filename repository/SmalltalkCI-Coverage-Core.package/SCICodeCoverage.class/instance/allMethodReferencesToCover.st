helpers
allMethodReferencesToCover

	| methods |
	methods := self class methodReferencesFor: self allClassesToCover.
	
	methods := methods , self extensionMethodsForPackages asArray.
	
	^ methods reject: [:method | self class cannotBeCovered: method]