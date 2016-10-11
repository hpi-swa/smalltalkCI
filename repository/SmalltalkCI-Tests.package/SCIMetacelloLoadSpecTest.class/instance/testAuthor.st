testing
testAuthor
	| currentAuthor |
	currentAuthor := SmalltalkCI getAuthor.
	
	SCIMetacelloLoadSpec setAuthor: ''.
	SCIMetacelloLoadSpec new.
	self assert: SmalltalkCI getAuthor equals: SCIMetacelloLoadSpec defaultAuthor.
	
	(Smalltalk at: #MetacelloPlatform) current authorName: currentAuthor.
	self assert: SmalltalkCI getAuthor equals: currentAuthor
		
		
	