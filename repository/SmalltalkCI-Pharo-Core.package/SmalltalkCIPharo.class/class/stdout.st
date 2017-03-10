compatibility
stdout
	^ (FileStream stdout name == #stdout)
		ifTrue: [ FileStream stdout ]
		ifFalse: [
			"Work around Windows hack"
			StdOut := MultiByteFileStream newForStdio
				openOnHandle: FileStream stdioHandles second
				name: #stdout
				forWrite: true.
			StdOut ]