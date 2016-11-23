helpers
methodsToCoverForPackages
	^ self coverageAt: #packages
		do: [ :packageNames | | packages |
			packages := (SmalltalkCI resolvedPackageNames: packageNames) collect: [ :resolvedName |
				SmalltalkCI packageNamed: resolvedName ifAbsent: [
					SmalltalkCI printToStdout: 'Package "', resolvedName, '" not found.' ] ].
			self class methodsUnderTestIn: packages ]