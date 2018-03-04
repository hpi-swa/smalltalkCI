printing
printOn: aStream

	self instructions 
		do: [ :e | aStream print: e ]
		separatedBy: [ aStream lf; lf ].