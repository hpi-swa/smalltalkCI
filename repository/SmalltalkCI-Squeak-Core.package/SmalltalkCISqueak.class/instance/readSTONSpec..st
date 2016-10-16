private
readSTONSpec: aFilename
	| stream |
	stream := StandardFileStream oldFileNamed: aFilename.
  	stream := MultiByteFileStream newFrom: stream.
	projectDirectory := stream directory fullName.	
	self spec: ((Smalltalk at: #SmalltalkCISpec) fromStream: stream).
	stream close