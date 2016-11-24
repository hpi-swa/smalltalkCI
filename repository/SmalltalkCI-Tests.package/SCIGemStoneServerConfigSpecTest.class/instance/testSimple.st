testing
testSimple
	| sessionName |
	self config
		defaultSessionName: 'session123';
		gemConfPath: 'gemConfPath';
		stoneConfPath: 'stoneConfPath';
		timeZone: '+1'.
	
	self
		assert: 'session123' equals: self config defaultSessionName;
		assert: 'gemConfPath' equals: self config gemConfPath;
		assert: 'stoneConfPath' equals: self config stoneConfPath;
		assert: '+1' equals: self config timeZone.
		
	sessionName := SCIGemStoneServerConfigSpec defaultSessionName.
	SCIGemStoneServerConfigSpec defaultSessionName: 'session123'.
	self assert: 'session123' equals: SCIGemStoneServerConfigSpec defaultSessionName.
	SCIGemStoneServerConfigSpec defaultSessionName: nil.
	self assert: 'travis' equals: SCIGemStoneServerConfigSpec defaultSessionName.
	SCIGemStoneServerConfigSpec defaultSessionName: sessionName
