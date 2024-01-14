compatibility
packageNameForMethod: aMethodReference
	^ ((Smalltalk at: #RPackageOrganizer) default packageDefiningOrExtendingMethod: aMethodReference compiledMethod) packageName