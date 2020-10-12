exporting
addMethods: methodReferences to: classCoverage atKey: aSymbol

	methodReferences do: [:methodReference |
		((classCoverage at: methodReference actualClass ifAbsentPut: [Dictionary new])
			at: aSymbol
			ifAbsentPut: [OrderedCollection new]) addLast: methodReference]