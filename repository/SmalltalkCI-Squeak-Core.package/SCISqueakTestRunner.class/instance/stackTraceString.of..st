private
stackTraceString: err of: aTestCase
	^ String streamContents: [ :str |
		| context |
		context := err signalerContext.
		[ context isNil or: [ context receiver == aTestCase and: [ context selector == #runCase ] ] ] whileFalse: [
			str print: context.
			(self class isTestMethod: context method)
				ifTrue: [ | pcRange code |
					pcRange := [
						context debuggerMap
							rangeForPC: context pc
							in: context method
							contextIsActiveContext: false ]
								on: MessageNotUnderstood
								do: [
									"fallback for Squeak < 5.2"
									context debuggerMap
										rangeForPC: context pc
										contextIsActiveContext: false ].
					code := context method getSource asString copyFrom: pcRange first to: pcRange last.
					str nextPutAll: ' ...', code ].
			str cr.
			context := context sender ] ]
