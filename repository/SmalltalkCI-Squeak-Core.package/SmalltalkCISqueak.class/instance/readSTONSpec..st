private
readSTONSpec: aFilename
	| stream |
	stream := StandardFileStream oldFileNamed: aFilename.
  	stream := MultiByteFileStream newFrom: stream.
	projectDirectory := stream directory fullName.	
	[ self spec: ((Smalltalk at: #SmalltalkCISpec) fromStream: stream) ]
		on: STONReaderError do: [ :error |
			FileStream stdout nextPutAll: 'Cannot read STON config file for smalltalkCI:', Character cr, error asString; flush.
			SmalltalkImage current snapshot: false andQuitWithExitCode: 1].
	stream close