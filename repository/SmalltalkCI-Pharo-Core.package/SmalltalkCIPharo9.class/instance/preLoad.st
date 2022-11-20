executing
preLoad
	[ (IceRepositoryCreator new
		location: projectDirectory asFileReference;
		createRepository) register. ] 
		on: Error 
		do: [ :e |
		      	 self class printWarningToStdout: 'Could not register the tested repository with Iceberg.'.
		      	 self class printWarningToStdout: 'If you need to use Iceberg features in the CI, see github.com/hpi-swa/setup-smalltalkCI'.
			 self class printWarningToStdout: e printString ]