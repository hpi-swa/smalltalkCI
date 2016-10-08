printing
printStart
	| title summary separatorLength separator |
	title := runner suite name.
	summary := runner summary.
	separatorLength := (title size max: summary size) + 4. "4 for `#  #` (see below)"
	separator := String new: separatorLength withAll: $#.
	self newLine;
		setModeBoldBlue; print: separator; newLine;
		setModeBoldBlue; print: '# ', title, ' #'; newLine;
		setModeBoldBlue; print: '# ', summary, ' #'; newLine;
		setModeBoldBlue; print: separator; newLine; newLine;
		resetMode