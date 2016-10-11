testing
testResolveWith
	| list result |
	list := #('foo' 'bar' 'foo-bar' 'bar-foo' 'foo-car').
	self assert: #('foo') equals: (SmalltalkCI resolve: 'foo' with: list).
	self assert: #() equals: (SmalltalkCI resolve: 'zzz' with: list).

	result := SmalltalkCI resolve: 'foo-*' with: list.
	self assert: (result size = 2).
	self assert: (result includes: 'foo-bar').
	self assert: (result includes: 'foo-car').
	
	result := SmalltalkCI resolve: 'foo-.*' with: list.
	self assert: (result size = 2).
	self assert: (result includes: 'foo-bar').
	self assert: (result includes: 'foo-car').

	result := SmalltalkCI resolve: 'foo.*' with: list.
	self assert: (result size = 3).
	self assert: (result includes: 'foo').
	self assert: (result includes: 'foo-bar').
	self assert: (result includes: 'foo-car').

	result := SmalltalkCI resolve: '*' with: list.
	self assert: (result size = list size).
	result := SmalltalkCI resolve: '.*' with: list.
	self assert: (result size = list size).