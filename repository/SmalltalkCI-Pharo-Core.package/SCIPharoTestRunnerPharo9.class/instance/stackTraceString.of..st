private
stackTraceString: err of: aTestCase

	^ String streamContents: [ :str |
		  | context |
		  context := err signalerContext.
		  [
		  context isNil or: [
			  context receiver == aTestCase and: [
				  (self selectorIn: context) == #runCase ] ] ] whileFalse: [
			  str print: context.
			  (self class isTestMethod: context method) ifTrue: [
				  | pcRange code |
				  pcRange := context pcRangeContextIsActive: false.
				  code := context method sourceCode asString
					          copyFrom: pcRange first
					          to: pcRange last.
				  str nextPutAll: ' ...' , code ].
			  str cr.
			  context := context sender ] ]