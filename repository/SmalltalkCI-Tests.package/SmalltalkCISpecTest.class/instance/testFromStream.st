testing
testFromStream
	self assert: #() equals: (SmalltalkCISpec fromStream: (ReadStream on: '[]'))