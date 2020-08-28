exporting
coverageWriterClass

	^ self spec coverageDictionary
		at: #format
		ifPresent: [:coverageFormat | SCICoverageWriter writerClassFor: coverageFormat] 
		ifAbsent: [SCICoverallsWriter].