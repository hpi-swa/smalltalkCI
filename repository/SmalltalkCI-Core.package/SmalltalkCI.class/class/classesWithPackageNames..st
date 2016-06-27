class organization
classesWithPackageNames: packageNames
	| classes |
	classes := Set new.
	packageNames do: [ :name |
		classes addAll: (self classesInPackage: name) ].
	^ classes