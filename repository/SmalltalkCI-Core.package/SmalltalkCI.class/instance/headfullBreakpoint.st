helpers
headfullBreakpoint
	SmalltalkCI platformClass isHeadless ifFalse: [ self halt ]