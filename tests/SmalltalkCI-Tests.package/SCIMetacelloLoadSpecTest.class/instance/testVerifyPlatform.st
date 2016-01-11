testing
testVerifyPlatform
	self spec platform: SCISpec platformSymbol.
	self shouldnt: [ self spec verifyPlatform ] raise: Error.
	
	self spec platform: #bogus.
	self should: [ self spec verifyPlatform ] raise: Error
	
	