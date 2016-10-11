class organization
allPackageNames
	^ MCWorkingCopy allManagers collect: [ :wc | wc packageName ]