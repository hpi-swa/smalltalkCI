constants
errorExceptions

	^ (TestResult respondsTo: #allErrors)
	    ifTrue: [ TestResult allErrors , TestResult failure ]
	    ifFalse: [ super errorExceptions "<= Squeak 5.3" ]