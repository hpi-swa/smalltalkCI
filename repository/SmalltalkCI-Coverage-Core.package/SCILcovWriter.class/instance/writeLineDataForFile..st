exporting
writeLineDataForFile: lineData

	self stream 
		"We don't know the test name, just omit it."
		nextPutAll: 'TN:', self lineEnding;
		"LCOV requires absolute file paths"
		nextPutAll: 'SF:', self projectDirectory, SmalltalkCI pathNameDelimiter, (lineData at: 'name'), self lineEnding.

	self writeLines: (lineData at: 'coverage').
	
	self stream nextPutAll: 'end_of_record', self lineEnding.