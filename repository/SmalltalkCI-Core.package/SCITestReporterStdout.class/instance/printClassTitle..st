printing
printClassTitle: aClass
	self
		setModeBold;
		cr; print: aClass asString; cr;
		resetMode