testing
testSimple
	| smalltalkCI path |
	smalltalkCI := SmalltalkCI basicNew initialize.
	path := '/dir/to/project' copyReplaceAll: '/' with: SmalltalkCI pathNameDelimiter.
	smalltalkCI projectDirectory: path.
	self assert: '' equals: self spec directory.
	self assert: #() equals: self spec load.
	self assert: nil equals: self spec user.
	self assert: nil equals: self spec password.
	self assert: nil equals: self spec usernameEnvVar.
	self assert: nil equals: self spec passwordEnvVar.
	self deny: self spec onWarningLog.
	self deny: self spec useLatestMetacello.

	self spec
		directory: 'foodir';
		load: #('FooLoad');
		version: '1.2.3';
		usernameEnvVar: 'FOO_USER';
		passwordEnvVar: 'FOO_PASS';
		onWarningLog: true;
		useLatestMetacello: false.
	
	self
		assert: 'foodir' equals: self spec directory;
		assert: 'FooLoad' equals: self spec load first;
		assert: '1.2.3' equals: self spec version;
		assert: 'FOO_USER' equals: self spec usernameEnvVar;
		assert: 'FOO_PASS' equals: self spec passwordEnvVar;
		assert: self spec onWarningLog;
		deny: self spec useLatestMetacello;
		assert: ('filetree://', path, SmalltalkCI pathNameDelimiter, 'foodir')
			equals: (self spec repositoryUrlIn: smalltalkCI projectDirectory).
	
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
	
	self spec repository: 'repo'.	
	self assert: 'repo' equals: (self spec repository)