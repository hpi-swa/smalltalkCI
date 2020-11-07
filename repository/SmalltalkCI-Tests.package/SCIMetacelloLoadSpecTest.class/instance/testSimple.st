testing
testSimple
	| smalltalkCI |
	smalltalkCI := SmalltalkCI basicNew initialize.
	smalltalkCI projectDirectory: '/dir/to/project'.
	self assert: '' equals: self spec directory.
	self assert: #() equals: self spec load.
	self assert: '' equals: self spec user.
	self assert: '' equals: self spec password.
	self deny: self spec onWarningLog.
	self deny: self spec useLatestMetacello.
	
	self spec
		directory: 'foodir';
		load: #('FooLoad');
		version: '1.2.3';
		user: 'foo';
		password: 'bar';
		onWarningLog: true;
		useLatestMetacello: false.
	
	self
		assert: 'foodir' equals: self spec directory;
		assert: 'FooLoad' equals: self spec load first;
		assert: '1.2.3' equals: self spec version;
		assert: 'foo' equals: self spec user;
		assert: 'bar' equals: self spec password;
		assert: self spec onWarningLog;
		deny: self spec useLatestMetacello;
		assert: ('filetree:///dir/to/project', SmalltalkCI pathNameDelimiter, 'foodir')
			equals: (self spec filetreeRepositoryIn: smalltalkCI projectDirectory).
	
	self spec repository: 'repo'.	
	self assert: 'repo' equals: (self spec repository)