executing
load
	super load.
	(IceRepositoryCreator new
		location: projectDirectory asFileReference;
		createRepository) register.