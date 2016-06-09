testing
testRepository
	| repository |
	self assert: nil equals: (self spec url).
	
	self spec url: 'http://example.com/'.
	repository := self spec repository.
	self assert: true equals: (repository isKindOf: MCHttpRepository).
	self assert: '' equals: repository user.
	self assert: '' equals: repository password.
	
	self spec user: 'foo'; password: 'bar'.
	repository := self spec repository.
	self assert: true equals: (repository isKindOf: MCHttpRepository).
	self assert: 'foo' equals: repository user.
	self assert: 'bar' equals: repository password