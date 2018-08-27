private
loadAndQuit: fullPathToConfig
	"Convenience method for Bash integration"
	self load: fullPathToConfig.
	SmalltalkCI isHeadless ifTrue: [ SmalltalkCI saveAndQuitImage ]