compatibility
stdout
	
	^ ((Smalltalk at: #FileStream) stdout name == #stdout)
		ifTrue: [ (Smalltalk at: #FileStream) stdout ]
		ifFalse: [
			"Work around Windows hack"
			(StdOut isNil or: [ StdOut closed ]) ifTrue: [
				StdOut := (Smalltalk at: #MultiByteFileStream) newForStdio
					openOnHandle: (Smalltalk at: #FileStream) stdioHandles second
					name: #stdout
					forWrite: true.
				StdOut lineEndConvention: #crlf ].
			StdOut ]