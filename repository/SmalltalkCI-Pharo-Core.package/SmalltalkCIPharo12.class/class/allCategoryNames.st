class organization
allCategoryNames
	| packages |
	packages := Smalltalk organization packages.
	^ (OrderedCollection
		new: packages size
		streamContents: [ :stream |
			packages do: [ :package |
				stream nextPut: package name asString.
				package tags do: [ :tag |
					stream nextPut: tag categoryName asString ] ] ]) asSet asArray