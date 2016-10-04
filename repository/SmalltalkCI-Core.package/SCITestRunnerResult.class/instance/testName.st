accessing
testName
	^ String streamContents: [ :stream | self testCase printOn: stream ]