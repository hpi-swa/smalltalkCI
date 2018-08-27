private
testAndQuit: fullPathToConfig
	"Convenience method for Bash integration"
	| successful |
	successful := false.
	[ successful := self test: fullPathToConfig ]
		ensure: [ SmalltalkCI shutdown: successful ]