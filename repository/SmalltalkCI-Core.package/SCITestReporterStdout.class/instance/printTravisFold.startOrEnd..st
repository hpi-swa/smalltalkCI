printing
printTravisFold: foldName startOrEnd: startOrEnd
	SmalltalkCI isTravisBuild ifFalse: [ ^ self ].
	self print: (SmalltalkCI travisFold: foldName startOrEnd: startOrEnd); cr