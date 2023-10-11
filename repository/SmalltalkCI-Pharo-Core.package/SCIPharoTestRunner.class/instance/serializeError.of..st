private
serializeError: error of: aTestCase
	"We got an error from a test, let's serialize it so we can properly debug it later on..."

	| context testCaseMethodContext |
	context := error signalerContext.
	testCaseMethodContext := context findContextSuchThat: [ :ctx |
		                         ctx receiver == aTestCase and: [
			                         (self selectorIn: ctx) == #performTest ] ].
	context := context copyTo: testCaseMethodContext.

	[
	Smalltalk
		at: #FuelOutStackDebugAction
		ifPresent: [ :fosda |
		fosda serializeStackFromContext: context sender ] ]
		on: Error
		do: [ :err | "simply continue..." ]