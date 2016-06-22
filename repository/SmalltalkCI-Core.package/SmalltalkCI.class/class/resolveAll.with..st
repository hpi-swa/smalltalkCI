class organization
resolveAll: names with: knownNames
	| items |
	items := Set new.
	names do: [ :name |
		items addAll: (self resolve: name with: knownNames) ].
	^ items asArray