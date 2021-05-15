testing
testSimple
	self assert: true equals: self spec packages isEmpty.
	self assert: true equals: self spec versions isEmpty.
	self assert: nil equals: self spec url.
	self assert: '' equals: self spec user.
	self assert: '' equals: self spec password.
	self assert: nil equals: self spec usernameEnvVar.
	self assert: nil equals: self spec passwordEnvVar.
	
	self spec packages: #('foo' 'bar').
	self assert: 2 equals: self spec packages size.

	self spec versions: #('foo-aa.4' 'bar-bb.42').
	self assert: 2 equals: self spec versions size.
	
	self spec
		url: 'http://example.com';
		usernameEnvVar: 'FOO_USER';
		passwordEnvVar: 'FOO_PASS'.
	self assert: 'http://example.com' equals: self spec url.
	self assert: 'FOO_USER' equals: self spec usernameEnvVar.
	self assert: 'FOO_PASS' equals: self spec passwordEnvVar.
	
	SCIMockSmalltalkCI installDuring: [
		SCIMockSmalltalkCI
			setEnv: 'FOO_USER' to: 'user_foo';
			setEnv: 'FOO_PASS' to: 'pass_bar'.
		self assert: 'user_foo' equals: self spec user.
		self assert: 'pass_bar' equals: self spec password].
	
	self spec
		user: 'foo';
		password: 'bar'.
	self assert: 'foo' equals: self spec user.
	self assert: 'bar' equals: self spec password.