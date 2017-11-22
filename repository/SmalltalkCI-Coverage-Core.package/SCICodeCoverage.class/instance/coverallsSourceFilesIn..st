coveralls
coverallsSourceFilesIn: projectDirectory
	"See http://docs.coveralls.io/api-reference for value mapping"
	^ { 1->self coveredMethods. 0->self uncoveredMethods. nil->self excludedMethods }
		gather: [ :ea | ea value collect: [ :method |
			(self directoryFor: method in: projectDirectory) ifNotNil: [ :directory |
				self class
					coverallsDictFor: method
					in: directory
					projectDirectory: projectDirectory
					coverageValue: ea key ]]]