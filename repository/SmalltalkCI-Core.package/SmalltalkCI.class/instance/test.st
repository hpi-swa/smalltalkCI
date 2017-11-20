executing
test
	| hasThrownError |
	"self class withBuildStatusReportingDo: [ self basicTest ]"

	"test should not shutdown image in the future (see #242), the below is a terrible workaround and only to keep the behavior for GsDevKit compatibility"
	hasThrownError := false.
	self class withBuildStatusReportingDo: [
		[ self basicTest ] on: SCIError do: [ :e | 
			hasThrownError := true.
			"Create new error, GemStone does not allow to signal an exception twice"
			SCIError signal: e messageText ]].
	SmalltalkCI shutdown: hasThrownError not