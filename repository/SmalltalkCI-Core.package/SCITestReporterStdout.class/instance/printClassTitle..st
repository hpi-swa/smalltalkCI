printing
printClassTitle: aClass
	self
		setModeBold;
		newLine; print: aClass asString; newLine;
		resetMode