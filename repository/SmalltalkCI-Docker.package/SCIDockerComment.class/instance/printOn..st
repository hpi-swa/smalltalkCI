printing
printOn: aStream
	contents
		ifNotNil: [ 
			self contents lines
				do: [ :line | 
					aStream
						nextPutAll: '# ';
						nextPutAll: line ]
				separatedBy: [ aStream lf ] ]