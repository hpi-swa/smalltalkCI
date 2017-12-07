helpers
updateMetacello
	(Smalltalk at: #Metacello) new
		baseline: 'Metacello';
		repository: 'github://Metacello/metacello:master/repository';
		get.
	(Smalltalk at: #Metacello) new
		baseline: 'Metacello';
		repository: 'github://Metacello/metacello:master/repository';
		load: #( 'batch' )