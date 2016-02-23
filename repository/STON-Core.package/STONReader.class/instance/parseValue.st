parsing
parseValue
	| value |
	value := self parseSimpleValue.
	^ (self matchChar: $:)
		ifTrue: [ 
			(self isValidPropertyNameType: value)
				ifFalse: [ self error: 'unexpected property name type' ].
			Association key: value value: self parseValue ]
		ifFalse: [ value ]