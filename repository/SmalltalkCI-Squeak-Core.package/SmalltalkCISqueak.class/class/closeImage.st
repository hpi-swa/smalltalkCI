helpers
closeImage
	Smalltalk at: #WorldState ifPresent: [:global |
		global addDeferredUIMessage: [
			Smalltalk at: #SmalltalkImage ifPresent: [:image |
				image current snapshot: false andQuit: true ]]]