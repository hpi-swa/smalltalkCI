executing
loadVersion: aVersionName repository: aRepository
	| versionName reader |
	versionName := aVersionName.
	(aVersionName endsWith: '.mcz')
		ifFalse: [ versionName := versionName, '.mcz' ].
	
	reader := aRepository versionReaderForFileNamed: versionName.
	reader
		ifNil: [ self error: 'Version "', aVersionName asString, '" not found in ', aRepository asString ]
		ifNotNil: [ | version |
			version := reader version.
			[ version load ] on: Warning do: [ :ex |
				Transcript cr; show: ex description.
				SmalltalkCI platformClass isHeadless
					ifTrue: [ ex resume ]
					ifFalse: [ ex signal ]].
			self addLoadedClassesFrom: reader definitions.
			version workingCopy repositoryGroup addRepository: aRepository ]