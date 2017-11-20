external-deprecated
readSTONSpec: aFilename
	| reference |
	SmalltalkCI deprecated: 'Use "SmalltalkCISpec>>fromFile:" instead'.
	reference := aFilename asFileReference.
	"Remove once GsDevKit_home does not depend on this side effect anymore"
	projectDirectory := reference parent fullName.
	reference readStreamDo: [ :stream | 
		self spec: (SmalltalkCISpec fromStream: stream) ]