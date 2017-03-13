compatibility
stdout
	^ (FileStream stdout name == #stdout)
		ifTrue: [ FileStream stdout ]
		ifFalse: [
			"Work around Windows hack"
			(StdOut isNil or: [ StdOut closed ]) ifTrue: [
				StdOut := MultiByteFileStream newForStdio
					openOnHandle: FileStream stdioHandles second
					name: #stdout
					forWrite: true.
				StdOut lineEndConvention: #crlf ].
			StdOut ]