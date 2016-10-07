printing
printTravisFold: foldName action: action
	SmalltalkCI isTravisBuild ifFalse: [ ^ self ].
	self print: (SmalltalkCI travisFold: foldName action: action)