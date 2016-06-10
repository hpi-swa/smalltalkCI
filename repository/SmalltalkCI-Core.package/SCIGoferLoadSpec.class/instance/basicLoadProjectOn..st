executing
basicLoadProjectOn: aSmalltalkCI
	| gofer |
	gofer := Gofer new.
	gofer url: self url username: self user password: self password.
	self packages do: [ :package | gofer package: package].
	self versions do: [ :version | gofer version: version ].
	gofer load.
	self addLoadedClassesFrom: gofer references