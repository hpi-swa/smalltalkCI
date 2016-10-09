executing
run: aBlock cover: classesToCover spec: aSmalltalkCISpec in: aProjectDirectory
	self class coverallsDataFileExists ifFalse: [
		SmalltalkCI printToStdout: 'Coveralls data is not available. Skipping coverage testing...'.
		^ aBlock value
	].
	coverallsData := self readCoverallsData.
	spec := aSmalltalkCISpec.
	projectDirectory := aProjectDirectory.
	self installCoverageWrappersFor: classesToCover.
	[ ^ aBlock value ] ensure:
		[ self finishUp ]