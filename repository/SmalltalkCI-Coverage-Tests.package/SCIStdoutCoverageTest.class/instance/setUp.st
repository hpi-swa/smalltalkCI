running
setUp
	"Set the platformclass to a class that contains a mock stdout stream, so we can inspect the output of the SCIStdoutCoverageWriter"
	SCISmalltalkCIStdoutMock clearStdout.
	SmalltalkCI platformClass: SCISmalltalkCIStdoutMock.