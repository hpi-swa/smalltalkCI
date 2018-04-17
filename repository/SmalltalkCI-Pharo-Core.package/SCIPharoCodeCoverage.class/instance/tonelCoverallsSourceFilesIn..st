coveralls
tonelCoverallsSourceFilesIn: projectDirectory
	| sourceFilesCoverage |
	sourceFilesCoverage := OrderedCollection new.
	self allClassesToCover
		select: [ :class | class isMeta not ]
		thenDo: [ :classToCover | 
			[ sourceFilesCoverage add: (self tonelCoverallsSourceFileFor: classToCover in: projectDirectory) ]
				on: SCIError
				do: [ :signal | signal return ] ].
	^ sourceFilesCoverage asArray