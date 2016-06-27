class organization
classesInPackage: packageName
	| package |
	package := MCWorkingCopy allManagers
		detect: [ :wc | wc packageName = packageName ]
		ifNone: [ ^ #() ].
	^ package packageInfo classes