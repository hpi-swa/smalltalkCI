executing
versionNumberOf: aVersionString
	^ ((aVersionString copyAfterLast: $-) copyAfter: $.) asInteger