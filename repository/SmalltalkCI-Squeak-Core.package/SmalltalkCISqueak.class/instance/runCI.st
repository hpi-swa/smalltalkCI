executing
runCI
	super runCI.
	self class isHeadless ifFalse: [ ^ self ].
	
	Smalltalk at: #WorldState ifPresent: [:global |
		global addDeferredUIMessage: [
    			Smalltalk at: #SmalltalkImage ifPresent: [:image |
     	 			image current snapshot: true andQuit: true ]]]	