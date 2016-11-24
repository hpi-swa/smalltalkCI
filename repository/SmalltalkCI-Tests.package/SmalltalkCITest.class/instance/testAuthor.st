testing
testAuthor
	| currentAuthor |
	currentAuthor := SmalltalkCI getAuthor.
	
	[
	SmalltalkCI basicNew initialize.
	self deny: SmalltalkCI defaultAuthor isNil.
	] ensure: [
		SmalltalkCI setAuthor: currentAuthor.
		self assert: SmalltalkCI getAuthor equals: currentAuthor ]