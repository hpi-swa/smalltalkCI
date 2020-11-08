support
installDuring: aBlock

	| previousClass |
	previousClass := SmalltalkCI platformClass.
	SmalltalkCI platformClass: self.
	^ aBlock ensure: [
		SmalltalkCI platformClass: previousClass]