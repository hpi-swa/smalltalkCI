executing
run: aBlock cover: classesToCover spec: aSmalltalkCISpec in: aProjectDirectory
	spec := aSmalltalkCISpec.
	projectDirectory := aProjectDirectory.
	self installCoverageWrappersFor: classesToCover.
	[ ^ aBlock value ] ensure:
		[ self finishUp ]