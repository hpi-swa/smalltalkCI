testing
testAuthor
	| currentAuthor |
	currentAuthor := (Smalltalk at: #MetacelloPlatform) current authorName.
	(Smalltalk at: #MetacelloPlatform) current authorName: 'foo'.
	
	self spec prepareForCI.
	self assert: SCIMetacelloLoadSpec getAuthor equals: SCIMetacelloLoadSpec testAuthor.
	self spec finishUpAfterCI.
	
	(Smalltalk at: #MetacelloPlatform) current authorName: currentAuthor.
	self assert: SCIMetacelloLoadSpec getAuthor equals: currentAuthor
		
		
	