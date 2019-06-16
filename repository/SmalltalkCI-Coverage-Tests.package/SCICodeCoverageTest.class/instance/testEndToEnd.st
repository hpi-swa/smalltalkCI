testing
testEndToEnd
	| block coverage |
	self platformSupportsCoverageTesting ifFalse: [ ^ self ].
	
	"Skip on Pharo-6.0 (see #331)."
	((SmalltalkCI platformSymbol = #pharo) and: [
		SmalltalkCI platformClass platformNameBeginsWith: 'Pharo6.0' ]) ifTrue: [ ^ self ].
	
	block := [
		self assert: SCICodeCoverageTestTarget new someInstanceMethod].
	coverage := SmalltalkCI codeCoverageClass new
		spec: self class endToEndSpec;
		run: block;
		yourself.
	self assert: 1 equals: coverage coveredMethods size.
	self
		assert: (SCICodeCoverageTestTarget>>#someInstanceMethod) methodReference
		equals: coverage coveredMethods first.
	self assert: (coverage excludedMethods includes:
		(SCICodeCoverageTestTarget>>#someAbstractInstanceMethod) methodReference).

	self assert: (coverage includedMethods anySatisfy: [ :ea | ea actualClass == SCICodeCoverageTestTargetOther]).
	self assert: (coverage includedMethods anySatisfy: [ :ea | ea actualClass == SCICodeCoverageTestTargetOther class]).
	self assert: (coverage includedMethods allSatisfy: [ :ea | ea actualClass ~~ SCICodeCoverageTestTargetExcluded]).
	self assert: (coverage includedMethods allSatisfy: [ :ea | ea actualClass ~~ SCICodeCoverageTestTargetExcluded class]).
