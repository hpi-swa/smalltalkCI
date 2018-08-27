private
testAndQuit: fullPathToConfig
	| result |
	"Convenience method for Bash integration"
	[ result := self test: fullPathToConfig ]
		ensure: [ | successful |
			successful := result ifNotNil: [ result successful ] ifNil: [ false ].
			SmalltalkCI shutdown: successful ]