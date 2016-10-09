setup
installCoverageWrappersFor: classesToCover
	coverageWrappers := self coverageWrappersFor: classesToCover.
	coverageWrappers do: [ :each | each install ]