helpers
classesToCoverForPackages
	^ self coverageAt: #packages do: [ :packageNames |
		  SmalltalkCI platformClass classesForPackages:
			  (self filterLegalNames: packageNames) ]