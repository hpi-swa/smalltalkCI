executing
preLoad
	[ (IceRepositoryCreator new
		location: projectDirectory asFileReference;
		createRepository) register. ] 
		on: Error 
		do: [ :e |
		      	 self class printWarningToStdout: (String streamContents: [ :s |
			 	s << 'Could not register the tested repository with Iceberg.';
				  cr;
				  << 'If you need to use Iceberg features in the CI, see github.com/hpi-swa/setup-smalltalkCI';
				  cr;
			 	  << e printString ])]