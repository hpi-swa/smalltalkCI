setup
setUp
	ci := SmalltalkCI platformClass basicNew initialize.
	ci instVarNamed: #spec put: SmalltalkCISpec new