private
isTestMethod: aMethod
	"Compatibility function for older versions of Squeak that do not have CompiledMethod>>isTestMethod"
	^ (aMethod methodClass isKindOf: TestCase class)
		and: [ aMethod selector beginsWith: 'test' ]