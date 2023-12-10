helpers
classesToCoverForPackages
	^ self coverageAt: #packages
		do: [ :packageNames | SmalltalkCI platformClass classesForPackages: packageNames ]