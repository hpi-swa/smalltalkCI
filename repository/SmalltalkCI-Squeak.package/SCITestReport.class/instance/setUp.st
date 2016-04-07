running
setUp	
	self
		logCr;
		log: 'Running suite: ', suite name;
		logCr;
		write: '<?xml version="1.0" encoding="UTF-8"?>'; writeLf;
		write: '<testsuite name="', (self encode: suite name);
    		write: '" tests="', suite tests size, '">'.

	"Now this is ugly. We want to update the time and the number of failures
	and errors, but still at the same time stream a valid XML. So remember
	this position and add some whitespace, that we can fill later."
	suitePosition := stream position - 1.
	self write: (String new: 100 withAll: $ ); writeLf.

	"Initialize the test resources."
	suite resources do: [ :each |
		each isAvailable
			ifFalse: [ each signalInitializationError ] ]
