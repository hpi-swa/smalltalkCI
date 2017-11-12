accessing
name
	^ name ifNil: [
		specName ifNotNil: [
			SmalltalkCI deprecated: 'Use #name instead of #specName'.
			^ specName ].
		self class defaultName ]