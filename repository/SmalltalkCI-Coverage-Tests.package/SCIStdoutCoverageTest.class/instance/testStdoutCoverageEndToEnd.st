testing
testStdoutCoverageEndToEnd

	"use nil as project dir, SCIStdoutCoverageWriter shouldn't need it."
	SCIStdoutCoverageWriter new export: self class mockCoverage in: nil.
	self assert: self class mockCoverageOutput equals: SCISmalltalkCIStdoutMock stdoutContents.