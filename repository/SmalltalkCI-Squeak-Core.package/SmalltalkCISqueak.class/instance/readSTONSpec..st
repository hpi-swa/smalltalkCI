private
readSTONSpec: aFilename
	| stream |
	stream := StandardFileStream oldFileNamed: aFilename.
  	stream := MultiByteFileStream newFrom: stream.
	self spec: ((Smalltalk at: #SmalltalkCISpec) fromStream: stream).
	stream close