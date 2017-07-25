private
withLoadWarningsHandlerDo: aBlock
	"Pharo only.
	Workaround for https://pharo.fogbugz.com/f/cases/19280/The-default-operation-of-MCMergeOrLoadWarning-should-be-to-perform-the-load-not-cancel-the-operation.
	See also https://github.com/hpi-swa/smalltalkCI/issues/80."
	[ super withLoadWarningsHandlerDo: aBlock ]
			on: (Smalltalk globals at: #MCMergeOrLoadWarning)
			do: [ :ex | ex resume: true ]