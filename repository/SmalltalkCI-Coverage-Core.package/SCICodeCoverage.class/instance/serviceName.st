accessing
serviceName

	^ self spec coverageDictionary at: #service ifAbsent: [ #coveralls ]