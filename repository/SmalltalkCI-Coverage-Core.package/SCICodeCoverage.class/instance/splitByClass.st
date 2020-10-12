helpers
splitByClass

	| classDictionary |
	classDictionary := Dictionary new.
	self coveredMethods do: [:methodReference |
		(classDictionary at: methodReference actualClass ifAbsentPut: [SCICodeCoverage empty])
			coveredMethods addLast: methodReference].
	self includedMethods do: [:methodReference |
		(classDictionary at: methodReference actualClass ifAbsentPut: [SCICodeCoverage empty])
			includedMethods addLast: methodReference].
	self excludedMethods do: [:methodReference |
		(classDictionary at: methodReference actualClass ifAbsentPut: [SCICodeCoverage empty])
			excludedMethods addLast: methodReference].
	^ classDictionary
		