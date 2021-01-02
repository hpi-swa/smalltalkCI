testing
testEmptyStdoutCoverage

	"use nil as project dir, SCIStdoutCoverageWriter shouldn't need it."
	SCIStdoutCoverageWriter new export: SCICodeCoverage new in: nil.
	self assert: self class mockEmptyOutput equals: SCISmalltalkCIStdoutMock stdoutContents.