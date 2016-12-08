private
serializeError: error of: aTestCase
	"We got an error from a test, let's serialize it so we can properly debug it later on..."
	| context testCaseMethodContext |

	context := error signalerContext.
	testCaseMethodContext := context findContextSuchThat: [ :ctx |
		ctx receiver == aTestCase and: [ ctx selector == #performTest ]].
	context := context copyTo: testCaseMethodContext