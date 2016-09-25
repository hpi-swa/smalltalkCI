compatibility
closeImageWithExitCode: exitCode
	Smalltalk at: #WorldState ifPresent: [:global |
		global addDeferredUIMessage: [
			Smalltalk at: #SmalltalkImage ifPresent: [:image |
				image current snapshot: false andQuitWithExitCode: exitCode ]]]