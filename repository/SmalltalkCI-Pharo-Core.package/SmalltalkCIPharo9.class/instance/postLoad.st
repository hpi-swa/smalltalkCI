executing
postLoad
	[ (IceRepositoryCreator new
		location: projectDirectory asFileReference;
		createRepository) register. ] 
		on: Error 
		do: [ :e | self class printWarningToStdout: 'Could not register the tested repository to Iceberg for some reason.'.
			self class printWarningToStdout: e printString ]