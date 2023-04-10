helpers
extensionMethodsForPackages

	^ self coverageAt: #packages do: [:packageNames |
		SmalltalkCI extensionMethodsForPackages: packageNames]