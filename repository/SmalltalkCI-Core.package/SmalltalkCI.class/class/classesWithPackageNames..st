class organization
classesWithPackageNames: packageNames
	| classes |
	classes := Set new.
	packageNames do: [ :eachName |
		classes addAll: (self classesInPackage: eachName) ].
	^ classes