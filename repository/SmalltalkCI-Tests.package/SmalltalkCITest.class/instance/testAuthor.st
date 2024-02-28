testing
testAuthor
	| currentAuthor |
	currentAuthor := SmalltalkCI platformClass getAuthor.
	
	[
	SmalltalkCI platformClass: nil.
	self deny: SmalltalkCI platformClass defaultAuthor isNil.
	] ensure: [
		SmalltalkCI platformClass setAuthor: currentAuthor.
		self assert: SmalltalkCI platformClass getAuthor equals: currentAuthor ]