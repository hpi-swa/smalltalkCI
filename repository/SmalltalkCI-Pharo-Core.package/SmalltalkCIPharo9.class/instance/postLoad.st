executing
postLoad
	[ (IceRepositoryCreator new
		location: projectDirectory asFileReference;
		createRepository) register. ] 
		on: Error 
		do: [ :e | self class printWarningToStdout: 'Could not register the tested repository with Iceberg.'.
			self class printWarningToStdout: e printString ]