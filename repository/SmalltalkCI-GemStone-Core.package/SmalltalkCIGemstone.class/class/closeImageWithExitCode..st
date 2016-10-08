compatibility
closeImageWithExitCode: exitCode
	exitCode = 0 ifFalse: [ self error: 'Build failed' ]