executing
load
	self class withBuildStatusReportingDo: [ self basicLoad ].
	(IceRepositoryCreator new
		location: projectDirectory asFileReference;
		createRepository) register.
