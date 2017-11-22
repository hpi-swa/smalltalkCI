helpers
classesToCover
	^ ((self spec coverageDictionary at: #classes ifAbsent: [ #() ])
		select: [ :classSymbol | Smalltalk includesKey: classSymbol ])
		collect: [ :classSymbol | Smalltalk at: classSymbol ]