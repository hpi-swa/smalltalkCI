private
tonelCoverallsSourceFileFor: classToCover in: projectDirectory
	| sourceDirectory filePath |
	sourceDirectory := self tonelSourceDirectoryFor: projectDirectory.
	filePath := self class tonelFilePathFor: classToCover in: sourceDirectory.
	^ Dictionary
		newFrom:
			{('name' -> (self class relativePathOf: filePath to: projectDirectory)).
			('source_digest' -> (self class md5Of: filePath)).
			('coverage' -> (self tonelCoverageFor: classToCover in: filePath))}