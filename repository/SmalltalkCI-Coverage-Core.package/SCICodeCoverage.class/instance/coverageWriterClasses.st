exporting
coverageWriterClasses
	
	^ self spec coverageDictionary
		at: #format
		ifPresent: [:formatOption | |formats|
			formats := formatOption.
			"The user is allowed to only provide a single format for
			convenience, so convert it to a collection"
			(formats isSymbol or: [formats isCollection not]) ifTrue: [formats := {formats}].
			formats collect: [:format |
				SCICoverageWriter writerClassFor: format]]
		ifAbsent: [SCICoverallsWriter asOrderedCollection].