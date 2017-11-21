instance creation
fromStream: aStream
	| result |
	^ [ result := (Smalltalk at: #STON) fromStream: aStream.
		(result isKindOf: self)
			ifTrue: [ result ]
			ifFalse: [ SmalltalkCIInvalidSpec new ]]
				on: STONReaderError
					do: [ :e | SmalltalkCIInvalidSpec withError: e ]