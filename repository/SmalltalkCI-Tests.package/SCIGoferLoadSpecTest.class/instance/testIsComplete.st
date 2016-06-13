testing
testIsComplete
	self assert: false equals: (self spec isComplete).
	
	self spec
		url: 'http://example.com/';
		versions: #('MyProject-fn.14');
		packages: #().
	self assert: true equals: (self spec isComplete).

	self spec versions: #().
	self assert: false equals: (self spec isComplete).

	self spec packages: #('MyPackage').
	self assert: true equals: (self spec isComplete)