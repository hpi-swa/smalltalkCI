bootstrapping
installSTONWithMetacello
	(Smalltalk at: #Metacello) new
      	configuration: 'Ston';
      	version: #stable;
      	repository: 'http://ss3.gemstone.com/ss/STON';
      	load