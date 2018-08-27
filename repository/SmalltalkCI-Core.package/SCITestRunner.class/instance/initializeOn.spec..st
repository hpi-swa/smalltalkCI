initialize-release
initializeOn: aTestSuite spec: aSCISpec
	self spec: aSCISpec.
	suite := aTestSuite.
	result := SCITestResult on: aTestSuite spec: aSCISpec