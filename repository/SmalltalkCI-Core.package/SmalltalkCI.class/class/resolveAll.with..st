class organization
resolveAll: names with: knownNames
	| items |
	items := Set new.
	names do: [ :n |
		items addAll: (self resolve: n with: knownNames) ].
	^ items asArray