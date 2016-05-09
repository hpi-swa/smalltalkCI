private
stackTraceString: err of: aTestCase
	^ String streamContents: [ :str |
		| context |
		context := err signalerContext.
		[ context isNil or: [ context receiver == aTestCase and: [ context methodSelector == #runCase ] ] ] whileFalse: [
			str print: context.
			(self isTestMethod: context method)
				ifTrue: [ | pcRange code |
					pcRange := context debuggerMap rangeForPC: context pc contextIsActiveContext: false.
					code := context method getSource asString copyFrom: pcRange first to: pcRange last.
					str nextPutAll: ' ...', code ].
			str lf.
			context := context sender ] ] 