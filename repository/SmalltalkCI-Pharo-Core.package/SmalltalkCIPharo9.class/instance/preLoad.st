executing
preLoad
	(spec loading anySatisfy: [ :aLoadingSpec | aLoadingSpec registerInIceberg ])
	      ifFalse: [ ^ self ].
	      
	[ (IceRepositoryCreator new
		location: projectDirectory asFileReference;
		createRepository) register. ] 
		on: Error 
		do: [ :e |
		      	 self class printWarningToStdout: (String streamContents: [ :s |
			 	s << 'Could not register the tested repository with Iceberg.';
				  cr;
				  << 'If you need to use Iceberg features in the CI, you need to have the full git history available.';
				  cr;
				  << 'see github.com/hpi-swa/setup-smalltalkCI for an example in Github Action.';
				  cr;
			 	  << e printString ])]
