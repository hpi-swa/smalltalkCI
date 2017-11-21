helpers
customScripts: aPhase
	| input |
	input := self instVarNamed: aPhase.
	input ifNil: [ ^ #() ].
	(input isKindOf: SCICustomScript) ifTrue: [ ^ {input} ].
	input isString ifTrue: [ ^ { SCICustomScript newForPath: input } ].
	input isCollection ifTrue: [
		| scripts |
		scripts := OrderedCollection new.
		input do: [ :each |
			(each isKindOf: SCICustomScript) ifTrue: [ scripts add: each ].
			each isString ifTrue: [ scripts add: (SCICustomScript newForPath: each) ]].
		^ scripts ].
	self error: 'Invalid input: ', input asString