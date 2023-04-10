coveralls
coverallsDictFor: methodReference in: aDirectoryName projectDirectory: projectDirectory coverageValue: aValue
	| filePath |
	filePath := (self filePathFor: methodReference in: aDirectoryName).
	^ Dictionary newFrom: {
			('name' -> (self relativeUnixPathOf: filePath to: projectDirectory)).
			('source_digest' -> (self md5Of: filePath)).
			('coverage' -> (Array new: (self linesOf: filePath) withAll: aValue))}