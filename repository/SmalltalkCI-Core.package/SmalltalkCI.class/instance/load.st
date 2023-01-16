executing
load
	self class withBuildStatusReportingDo: [ self basicLoad ].
	self postLoad