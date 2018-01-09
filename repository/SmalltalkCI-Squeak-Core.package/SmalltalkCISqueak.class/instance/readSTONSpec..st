external-deprecated
readSTONSpec: aFilename
	| stream |
	SmalltalkCI deprecated: 'Use "SmalltalkCISpec>>fromFile:" instead'.
	stream := StandardFileStream oldFileNamed: aFilename.
  	stream := MultiByteFileStream newFrom: stream.
	self spec: (SmalltalkCISpec fromStream: stream).
	stream close