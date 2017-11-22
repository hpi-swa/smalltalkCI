testing
testEndToEnd
	| block coverage |
	self platformSupportsCoverageTesting ifFalse: [ ^ self ].
	
	block := [
		self assert: SCICodeCoverageTestTarget new someInstanceMethod].
	coverage := SmalltalkCI codeCoverageClass new
		run: block spec: self class endToEndSpec;
		yourself.
	self assert: 1 equals: coverage coveredMethods size.
	self
		assert: (SCICodeCoverageTestTarget>>#someInstanceMethod) methodReference
		equals: coverage coveredMethods first.
	self assert: (coverage excludedMethods includes:
		(SCICodeCoverageTestTarget>>#someAbstractInstanceMethod) methodReference).

	self assert: (coverage includedMethods anySatisfy: [ :ea | ea actualClass == SCIDummySpec]).
	self assert: (coverage includedMethods anySatisfy: [ :ea | ea actualClass == SCIDummySpec class]).
	self assert: (coverage includedMethods allSatisfy: [ :ea | ea actualClass ~~ SCICodeCoverageTestNoTarget]).
	self assert: (coverage includedMethods allSatisfy: [ :ea | ea actualClass ~~ SCICodeCoverageTestNoTarget class]).
