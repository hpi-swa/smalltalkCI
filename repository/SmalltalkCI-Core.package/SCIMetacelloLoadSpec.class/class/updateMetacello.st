helpers
updateMetacello
	(Smalltalk at: #Metacello) new
		baseline: 'Metacello';
		repository: 'github://dalehenrich/metacello-work:master/repository';
		get.
	(Smalltalk at: #Metacello) new
		baseline: 'Metacello';
		repository: 'github://dalehenrich/metacello-work:master/repository';
		load: #( 'batch' )