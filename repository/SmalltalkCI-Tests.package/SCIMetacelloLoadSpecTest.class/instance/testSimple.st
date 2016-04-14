testing
testSimple
	| smalltalkCI |
	smalltalkCI := SmalltalkCI basicNew initialize.
	smalltalkCI projectDirectory: '/dir/to/project'.

	self spec
		directory: 'foodir';
		load: #('FooLoad');
		version: '1.2.3';
		onWarningLog: true;
		originalAuthor: 'The Author'.
	
	self
		assert: self spec directory equals: 'foodir';
		assert: self spec load first equals: 'FooLoad';
		assert: self spec version equals: '1.2.3';
		assert: self spec onWarningLog equals: true;
		assert: self spec originalAuthor equals: 'The Author';
		assert: (self spec loadRepositoryFor: smalltalkCI) equals: 'filetree:///dir/to/project/foodir'.
		
	self spec repository: 'repo'.
	
	self assert: (self spec loadRepositoryFor: smalltalkCI) equals: 'repo'
