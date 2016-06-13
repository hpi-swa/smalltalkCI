testing
testSimple
	self assert: true equals: self spec packages isEmpty.
	self assert: true equals: self spec versions isEmpty.
	self assert: nil equals: self spec url.
	self assert: '' equals: self spec user.
	self assert: '' equals: self spec password.
	
	self spec packages: #('foo' 'bar').
	self assert: 2 equals: self spec packages size.

	self spec versions: #('foo-aa.4' 'bar-bb.42').
	self assert: 2 equals: self spec versions size.
	
	self spec url: 'http://example.com'; user: 'foo'; password: 'bar'.
	self assert: 'http://example.com' equals: self spec url.
	self assert: 'foo' equals: self spec user.
	self assert: 'bar' equals: self spec password.
	
	
