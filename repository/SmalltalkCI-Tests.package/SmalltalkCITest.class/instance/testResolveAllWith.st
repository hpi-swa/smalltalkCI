testing
testResolveAllWith
	| list result |
	list := #('foo' 'bar' 'foo-bar' 'bar-foo' 'foo-car').
	self assert: #('foo') equals: (SmalltalkCI resolveAll: #('foo') with: list).
	self assert: #() equals: (SmalltalkCI resolveAll: #('zzz') with: list).

	result := SmalltalkCI resolveAll: #('foo' 'bar') with: list.
	self assert: (result size = 2).
	self assert: (result includes: 'foo').
	self assert: (result includes: 'bar').

	result := SmalltalkCI resolveAll: #('foo-*' 'bar.*') with: list.
	self assert: (result size = 4).
	self assert: (result includes: 'foo-bar').
	self assert: (result includes: 'foo-car').
	self assert: (result includes: 'bar').
	self assert: (result includes: 'bar-foo').

	result := SmalltalkCI resolveAll: #('*') with: list.
	self assert: (result size = list size).
	result := SmalltalkCI resolveAll: #('.*') with: list.
	self assert: (result size = list size).