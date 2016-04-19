accessing
isCoverageTestingEnabled
	^ self class supportsCoverage and: [ self spec testing includesKey: #coverage ]