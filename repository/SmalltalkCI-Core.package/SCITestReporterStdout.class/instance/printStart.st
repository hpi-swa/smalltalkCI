printing
printStart
	| title summary textLength separator |
	title := runner suite name.
	summary := runner summary.
	textLength := (title size max: summary size).
	separator := String new: (textLength + 4) withAll: $#. "+ 4 for `#  #` (see below)"
	self newLine;
		setModeBoldBlue; print: separator; newLine;
		setModeBoldBlue; print: '# ', (title padded: #right to: textLength with: Character space), ' #'; newLine;
		setModeBoldBlue; print: '# ', (summary padded: #right to: textLength with: Character space), ' #'; newLine;
		setModeBoldBlue; print: separator; newLine; newLine;
		resetMode