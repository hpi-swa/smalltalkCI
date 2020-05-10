testing
uploadsCoverageReportAutomatically

	^ self spec coverageDictionary at: #auto_upload ifAbsent: [ true ]