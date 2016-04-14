testing
testSimple
	self config
		defaultSessionName: 'session123';
		gemConfPath: 'gemConfPath';
		stoneConfPath: 'stoneConfPath';
		timeZone: '+1'.
	
	self
		assert: 'session123' equals: self config defaultSessionName;
		assert: 'gemConfPath' equals: self config gemConfPath;
		assert: 'stoneConfPath' equals: self config stoneConfPath;
		assert: '+1' equals: self config timeZone