helpers
classesToCoverForPackages
	^ self coverageAt: #packages
		do: [ :packageNames | SmalltalkCI classesForPackages: packageNames ]