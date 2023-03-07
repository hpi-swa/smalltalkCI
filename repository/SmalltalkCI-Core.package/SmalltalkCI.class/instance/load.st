executing
load
	self preLoad.
	self class withBuildStatusReportingDo: [ self basicLoad ].