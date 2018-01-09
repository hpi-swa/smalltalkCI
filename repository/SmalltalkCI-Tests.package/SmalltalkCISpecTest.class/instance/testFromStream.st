testing
testFromStream
	#('SmalltalkCISpec {}' 'SmalltalkCISpec { #loading : [] }') do: [ :each |
		self assert: (SmalltalkCISpec fromStream: each readStream) isValid].

	#('SmalltalkCISpec {,}' '[]' '{}' '1' '&^#%,,') do: [ :each |
		self deny: (SmalltalkCISpec fromStream: each readStream) isValid].
	
	self assert: ((SmalltalkCISpec fromStream: ',' readStream) originalError isKindOf: Error)