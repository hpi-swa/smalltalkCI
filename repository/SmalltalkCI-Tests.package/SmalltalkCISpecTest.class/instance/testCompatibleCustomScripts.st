testing
testCompatibleCustomScripts
	| preLoading postLoading preTesting postTesting |
	self spec: (SmalltalkCISpec new
		preLoading: 'some.st';
		postLoading: #('some.st' 'other.st');
		preTesting: {
			'some.st'.
			SCICustomScript newForPath: 'other.st'.
			SCICustomScript new
				path: 'another.st';
				platforms: {SmalltalkCI platformSymbol};
				yourself.
			SCICustomScript new
				path: 'incompatible.st';
				platforms: #(#incompatible);
				yourself. };
		postTesting: (SCICustomScript new path: 'some.st'; platforms: #(#unknown); yourself) ;
		yourself).

	preLoading := self spec compatibleCustomScripts: 'preLoading'.
	postLoading := self spec compatibleCustomScripts: 'postLoading'.
	preTesting := self spec compatibleCustomScripts: 'preTesting'.
	postTesting := self spec compatibleCustomScripts: 'postTesting'.
	
	self assert: 1 equals: preLoading size.
	self assert: (preLoading first isKindOf: SCICustomScript).
	self assert: 'some.st' equals: preLoading first path.

	self assert: 2 equals: postLoading size.
	self assert: (postLoading allSatisfy: [ :each | each isKindOf: SCICustomScript ]).
	self assert: 'some.st' equals: postLoading first path.
	self assert: 'other.st' equals: postLoading second path.

	self assert: 3 equals: preTesting size.
	self assert: (preTesting allSatisfy: [ :each | each isKindOf: SCICustomScript ]).
	self assert: 'some.st' equals: preTesting first path.
	self assert: 'other.st' equals: preTesting second path.
	self assert: 'another.st' equals: preTesting third path.

	self assert: postTesting isEmpty
	