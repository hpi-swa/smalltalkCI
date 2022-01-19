constants
errorExceptions

	(TestResult respondsTo: #allErrors) ifFalse: ["<= Squeak 5.3"
		^ super errorExceptions].
	
	^ TestResult allErrors , TestResult failure