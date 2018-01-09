private
withLoadWarningsHandlerDo: aBlock
	"compensate for older versions of Metacello"
	aBlock
		on: self loadWarnings
		do: [ :ex |
			(self failOn includes: ex class name)
				ifTrue: [ SCIError signal: ex description ].
			self onWarningLog
				ifTrue: [ SmalltalkCI printWarningToStdout: ex description ].
			ex pass ]