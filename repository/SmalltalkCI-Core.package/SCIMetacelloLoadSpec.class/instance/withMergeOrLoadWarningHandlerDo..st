private
withMergeOrLoadWarningHandlerDo: aBlock
	"Pharo only.
	Workaround for https://pharo.fogbugz.com/f/cases/19280/The-default-operation-of-MCMergeOrLoadWarning-should-be-to-perform-the-load-not-cancel-the-operation.
	See also https://github.com/hpi-swa/smalltalkCI/issues/80."
	Smalltalk globals
		at: #MCMergeOrLoadWarning
		ifPresent: [ :class |
			aBlock
				on: class
				do: [ :ex | ex resume: true ] ]
		ifAbsent: aBlock