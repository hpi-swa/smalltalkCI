initialize-release
initialize

	super initialize.
	"Make SmalltalkCI a variable to allow mocking"
	self sci: SmalltalkCI.