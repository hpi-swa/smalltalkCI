format
writerClassFor: coverageFormat

	self subclassesDo: [:writerClass |
		writerClass coverageFormat = coverageFormat ifTrue: [^ writerClass]].
	
	"We couldn't find a writer for the specified format."
	SCIError signal:
		'Unknown coverage format: ', coverageFormat printString, String cr,
		'Supported formats are: ', self supportedFormatsString, String cr,
		'See: https://github.com/hpi-swa/smalltalkCI/blob/master/docs/COVERAGE.md'.