compatibility
assureDirectoryExistence: aDirectory
	"Currently only implemented for Squeak & Pharo"
	^ self platformClass assureDirectoryExistence: aDirectory