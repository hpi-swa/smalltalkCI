helpers
closeAndSaveImage
	Smalltalk at: #WorldState ifPresent: [:global |
		global addDeferredUIMessage: [
			Smalltalk at: #SmalltalkImage ifPresent: [:image |
				"For compatibility reasons, do not snapshot and quit at the same time."
				(image current snapshot: true andQuit: false)
					ifFalse: [ image current snapshot: false andQuit: true ]]]]